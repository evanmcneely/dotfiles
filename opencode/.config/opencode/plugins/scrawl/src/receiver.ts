import { randomUUID } from "node:crypto"
import { lstat, mkdir, open, readFile, readdir, rename, rm, writeFile } from "node:fs/promises"
import { dirname, join, posix } from "node:path"
import { pathToFileURL } from "node:url"
import { digest } from "./bundle.ts"
import { beginSchema, CHUNK_SIZE, MAX_BYTES, type Begin } from "./rpc.ts"

export function safePath(path: string) {
  if (!path || path.includes("\\") || path.includes(":") || /[\x00-\x1f]/.test(path)
    || path.startsWith("/") || posix.normalize(path) !== path
    || path.split("/").some((part) => part === "." || part === ".." || !part)) {
    throw new Error(`Invalid bundle path: ${path}`)
  }
  return path
}

export type Prompt = {
  sessionID: string; id: string; text: string; delivery: "queue"
  files: { uri: string; name: string }[]
}
type Upload = {
  input: Begin; staging: string; directory: string; touched: number; busy: boolean
  received: Map<string, number>; result?: Promise<{ directory: string }>
}

export class Receiver {
  private uploads = new Map<string, Upload>()
  private root: string
  private prompt: (input: Prompt) => Promise<unknown>
  constructor(root: string, prompt: (input: Prompt) => Promise<unknown>) {
    this.root = root
    this.prompt = prompt
  }

  async begin(value: Begin) {
    const input = beginSchema.parse(value)
    if (this.uploads.size >= 4) throw new Error("Too many Scrawl uploads; try again later")
    const paths = new Set<string>()
    let bytes = 0
    for (const file of input.files) {
      safePath(file.path)
      if (paths.has(file.path)) throw new Error("Duplicate bundle path")
      paths.add(file.path)
      bytes += file.size
    }
    for (const path of paths) {
      let parent = posix.dirname(path)
      while (parent !== ".") {
        if (paths.has(parent)) throw new Error("File/directory path conflict")
        parent = posix.dirname(parent)
      }
    }
    if (bytes > MAX_BYTES) throw new Error("Capture exceeds the 16 GiB upload limit")
    if (!paths.has("scrawl.json") || !paths.has("summary.md")) throw new Error("Incomplete Scrawl bundle")
    const uploadID = randomUUID()
    const staging = join(this.root, `.incoming-${uploadID}`)
    const directory = join(this.root, `scrawl-${uploadID}.scrawl`)
    // Reserve a slot before awaiting I/O, including concurrent begin calls.
    const upload: Upload = { input, staging, directory, touched: Date.now(), busy: true, received: new Map() }
    this.uploads.set(uploadID, upload)
    try {
      await mkdir(this.root, { recursive: true, mode: 0o700 })
      await mkdir(staging, { mode: 0o700 })
      for (const file of input.files) {
        const path = join(staging, file.path)
        await mkdir(dirname(path), { recursive: true, mode: 0o700 })
        const handle = await open(path, "wx", 0o600)
        await handle.close()
        upload.received.set(file.path, 0)
      }
      return { uploadID }
    } catch (error) {
      this.uploads.delete(uploadID)
      await rm(staging, { recursive: true, force: true })
      throw error
    } finally { upload.busy = false }
  }

  private get(id: string) {
    const upload = this.uploads.get(id)
    if (!upload) throw new Error("Scrawl upload expired or does not exist")
    upload.touched = Date.now()
    return upload
  }

  async chunk(input: { uploadID: string; path: string; offset: number; data: string }) {
    const upload = this.get(input.uploadID)
    if (upload.busy || upload.result) throw new Error("Scrawl upload is busy or already finished")
    const file = upload.input.files.find((file) => file.path === input.path)
    if (!file) throw new Error("File is not in the upload manifest")
    const data = Buffer.from(input.data, "base64")
    if (data.length === 0 || data.length > CHUNK_SIZE || data.toString("base64") !== input.data) {
      throw new Error("Invalid upload chunk")
    }
    const received = upload.received.get(file.path)!
    if (input.offset !== received || received + data.length > file.size) throw new Error("Invalid chunk offset or size")
    upload.busy = true
    try {
      const handle = await open(join(upload.staging, file.path), "r+")
      try {
        let written = 0
        while (written < data.length) {
          const result = await handle.write(data, written, data.length - written, received + written)
          if (!result.bytesWritten) throw new Error("Could not write upload chunk")
          written += result.bytesWritten
        }
      } finally { await handle.close() }
      upload.received.set(file.path, received + data.length)
      return { received: received + data.length }
    } finally { upload.busy = false }
  }

  async finish(id: string) {
    const upload = this.get(id)
    if (upload.result) return upload.result
    if (upload.busy) throw new Error("Scrawl upload is busy")
    // Retain the promise, including failures: an ambiguous prompt response must not cause a second send.
    upload.result = this.commit(upload)
    return upload.result
  }

  private async commit(upload: Upload) {
    for (const file of upload.input.files) {
      if (upload.received.get(file.path) !== file.size) throw new Error(`Incomplete upload: ${file.path}`)
      if (await digest(join(upload.staging, file.path)) !== file.sha256) throw new Error(`Capture changed during upload: ${file.path}`)
    }
    const rebase = (text: string) => text.replaceAll(upload.input.source, upload.directory)
    const summary = rebase(await readFile(join(upload.staging, "summary.md"), "utf8"))
    const manifest = JSON.parse(await readFile(join(upload.staging, "scrawl.json"), "utf8"))
    const contactSheet = safePath(manifest.contactSheet ?? "contact-sheet.png")
    if (!upload.received.has(contactSheet)) throw new Error("Capture's contact sheet is missing")
    // Rebase path-valued strings without breaking JSON escaping (notably Windows source paths).
    const rewrite = (value: unknown): unknown => {
      if (typeof value === "string") return rebase(value)
      if (Array.isArray(value)) return value.map(rewrite)
      if (value && typeof value === "object") return Object.fromEntries(Object.entries(value).map(([k, v]) => [k, rewrite(v)]))
      return value
    }
    await writeFile(join(upload.staging, "scrawl.json"), JSON.stringify(rewrite(manifest), null, 2))
    await writeFile(join(upload.staging, "summary.md"), summary)
    await rename(upload.staging, upload.directory)
    const quoted = "'" + upload.directory.replaceAll("'", "'\\''") + "'"
    await this.prompt({
      sessionID: upload.input.sessionID,
      id: `msg_${randomUUID().replaceAll("-", "")}`,
      text: `${summary.trim()}\n\nFull Scrawl bundle on this server: ${upload.directory}\nRead contact-sheet.png and frames/ before acting. All available media has been transferred.\nUse scrawl zoom ${quoted} --at <M:SS> to inspect motion, scrawl frames for a range, or scrawl export for video.`,
      files: [{ uri: pathToFileURL(join(upload.directory, contactSheet)).href, name: "contact-sheet.png" }],
      delivery: "queue",
    })
    return { directory: upload.directory }
  }

  async cancel(id: string) {
    const upload = this.uploads.get(id)
    if (!upload || upload.busy) return {}
    if (upload.result) {
      // Never delete a completed bundle: a queued prompt may already reference it.
      await upload.result.catch(() => {})
    }
    this.uploads.delete(id)
    await rm(upload.staging, { recursive: true, force: true })
    return {}
  }

  async expire(now = Date.now()) {
    for (const [id, upload] of this.uploads) {
      if (!upload.busy && now - upload.touched > 60 * 60 * 1000) await this.cancel(id)
    }
    // Recover staging folders left by a server crash. Never touch completed captures.
    let entries
    try { entries = await readdir(this.root) } catch (error) {
      if ((error as NodeJS.ErrnoException).code === "ENOENT") return
      throw error
    }
    for (const name of entries) {
      if (!/^\.incoming-[a-f0-9-]{36}$/.test(name)) continue
      if (this.uploads.has(name.slice(".incoming-".length))) continue
      const path = join(this.root, name)
      const stat = await lstat(path)
      if (stat.isDirectory() && now - stat.mtimeMs > 24 * 60 * 60 * 1000) {
        await rm(path, { recursive: true, force: true })
      }
    }
  }
}

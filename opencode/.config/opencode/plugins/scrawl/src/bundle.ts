import { createHash } from "node:crypto"
import { createReadStream } from "node:fs"
import { access, lstat, readdir, readFile } from "node:fs/promises"
import { homedir } from "node:os"
import { isAbsolute, join, resolve } from "node:path"
import type { BundleFile } from "./rpc.ts"

const transient = new Set([".media-pending", ".media-sending", ".deliver.json", ".deliver-failed.json"])

export async function capturesDirectory(home = homedir(), env = process.env) {
  if (env.SCRAWL_CAPTURES_DIR) return resolve(env.SCRAWL_CAPTURES_DIR)
  const fallback = process.platform === "win32"
    ? join(env.LOCALAPPDATA ?? join(home, "AppData/Local"), "scrawl/captures")
    : join(home, "Library/Application Support/scrawl/captures")
  let config: { capturesDir?: string }
  try {
    config = JSON.parse(await readFile(join(home, ".config/scrawl/config.json"), "utf8"))
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") return fallback
    throw new Error("Could not read Scrawl's config.json", { cause: error })
  }
  let directory = config.capturesDir?.trim()
  if (directory === "~" || directory?.startsWith("~/")) directory = home + directory.slice(1)
  if (!directory || !isAbsolute(directory)) return fallback
  try { await access(directory); return directory } catch { return fallback }
}

export async function latestBundle(directory: string) {
  const candidates: { directory: string; created: number }[] = []
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    if (!entry.isDirectory() || !entry.name.endsWith(".scrawl")) continue
    const path = join(directory, entry.name)
    try {
      const manifest = JSON.parse(await readFile(join(path, "scrawl.json"), "utf8"))
      if (!Number.isFinite(manifest.createdAtMs)) continue
      await access(join(path, "summary.md"))
      await access(join(path, manifest.contactSheet ?? "contact-sheet.png"))
      candidates.push({ directory: path, created: manifest.createdAtMs })
    } catch { /* An unfinished capture has no usable manifest/summary yet. */ }
  }
  candidates.sort((a, b) => b.created - a.created)
  if (!candidates[0]) throw new Error(`No completed .scrawl capture found in ${directory}`)
  return candidates[0].directory
}

export async function digest(path: string) {
  const hash = createHash("sha256")
  for await (const chunk of createReadStream(path)) hash.update(chunk)
  return hash.digest("hex")
}

export async function bundleFiles(directory: string): Promise<BundleFile[]> {
  for (const marker of [".media-pending", ".media-sending"]) {
    try { await access(join(directory, marker)) } catch { continue }
    throw new Error("Scrawl is still transferring this capture's media. Try again when it finishes.")
  }
  const files: BundleFile[] = []
  async function walk(relative: string) {
    for (const entry of await readdir(join(directory, relative), { withFileTypes: true })) {
      if (transient.has(entry.name)) continue
      const path = relative ? `${relative}/${entry.name}` : entry.name
      const absolute = join(directory, path)
      const stat = await lstat(absolute)
      if (stat.isSymbolicLink()) throw new Error(`Capture contains a symbolic link: ${path}`)
      if (stat.isDirectory()) await walk(path)
      else if (stat.isFile()) files.push({ path, size: stat.size, sha256: await digest(absolute) })
      else throw new Error(`Unsupported capture file: ${path}`)
    }
  }
  await walk("")
  const manifest = JSON.parse(await readFile(join(directory, "scrawl.json"), "utf8"))
  for (const media of [manifest.video, manifest.audio]) {
    if (typeof media === "string" && !files.some((file) => file.path === media)) {
      throw new Error(`Capture media is missing (${media}); Scrawl may have cleaned it up. A full transfer needs a capture with its original media.`)
    }
  }
  return files
}

export function recordedDestination(manifest: unknown, timeline?: unknown): string | undefined {
  const t = timeline as { session?: string } | undefined
  const m = manifest as { destination?: { session?: string } }
  return t?.session || m.destination?.session || undefined
}

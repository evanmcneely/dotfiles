import { test } from "node:test"
import assert from "node:assert/strict"
import { mkdtemp, mkdir, readFile, readdir, rm, symlink, writeFile } from "node:fs/promises"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { bundleFiles, capturesDirectory, latestBundle, recordedDestination } from "./bundle.ts"
import { Receiver, safePath, type Prompt } from "./receiver.ts"
import { CHUNK_SIZE, type Begin } from "./rpc.ts"
import { sendBundle } from "./send.ts"

async function fixture(t: { after: (fn: () => Promise<void>) => void }) {
  const root = await mkdtemp(join(tmpdir(), "opencode-scrawl-test-"))
  t.after(() => rm(root, { recursive: true, force: true }))
  const source = join(root, "local capture.scrawl")
  await mkdir(join(source, "frames"), { recursive: true })
  await writeFile(join(source, "scrawl.json"), JSON.stringify({
    createdAtMs: 100, contactSheet: "contact-sheet.png", video: "recording.mp4", audio: "audio.wav",
    keyframes: [{ file: "frames/frame-01.png" }], source,
  }))
  await writeFile(join(source, "summary.md"), `[scrawl · ${source}]\nOpen ${source}/frames/`)
  await writeFile(join(source, "contact-sheet.png"), "image fixture")
  await writeFile(join(source, "frames/frame-01.png"), "keyframe fixture")
  await writeFile(join(source, "recording.mp4"), Buffer.alloc(CHUNK_SIZE * 2 + 17, 71))
  await writeFile(join(source, "audio.wav"), "audio fixture")
  const prompts: Prompt[] = []
  const receiver = new Receiver(join(root, "remote"), async (prompt) => { prompts.push(prompt) })
  const input: Begin = { source, sessionID: "ses_current", files: await bundleFiles(source) }
  const transport = {
    begin: (input: Begin) => receiver.begin(input),
    chunk: (input: Parameters<Receiver["chunk"]>[0]) => receiver.chunk(input),
    finish: ({ uploadID }: { uploadID: string }) => receiver.finish(uploadID),
    cancel: ({ uploadID }: { uploadID: string }) => receiver.cancel(uploadID),
  }
  return { root, source, prompts, input, receiver, transport }
}

test("full multi-chunk transfer preserves all media and rebases paths before queueing", async (t) => {
  const f = await fixture(t)
  const progress: number[] = []
  const result = await sendBundle(f.input, f.transport, (sent) => progress.push(sent))
  assert.equal(f.prompts.length, 1)
  assert.equal(f.prompts[0].sessionID, "ses_current")
  assert.equal(f.prompts[0].delivery, "queue")
  assert.ok(f.prompts[0].files[0].uri.startsWith("file://"))
  assert.ok(f.prompts[0].text.includes(result.directory))
  assert.ok(!f.prompts[0].text.includes(f.source))
  for (const name of ["recording.mp4", "audio.wav", "frames/frame-01.png"]) {
    assert.deepEqual(await readFile(join(result.directory, name)), await readFile(join(f.source, name)))
  }
  assert.equal(JSON.parse(await readFile(join(result.directory, "scrawl.json"), "utf8")).source, result.directory)
  assert.equal(progress.at(-1), f.input.files.reduce((sum, file) => sum + file.size, 0))
  assert.deepEqual(await readdir(join(f.root, "remote")), [result.directory.split("/").at(-1)])
})

test("rejects path traversal, absolute paths, Windows paths, and ambiguous paths", () => {
  for (const path of ["../x", "/x", "frames/../../x", "a//b", "a/./b", "C:/x", "a\\b", "a\0b", "a/", "."]) {
    assert.throws(() => safePath(path), path)
  }
  assert.equal(safePath("frames/frame-01.png"), "frames/frame-01.png")
})

test("rejects duplicate paths, file/directory conflicts, and oversized bundles", async (t) => {
  const f = await fixture(t)
  await assert.rejects(f.receiver.begin({ ...f.input, files: [...f.input.files, f.input.files[0]] }), /Duplicate/)
  await assert.rejects(f.receiver.begin({ ...f.input, files: [...f.input.files, { ...f.input.files[0], path: "frames" }] }), /conflict/)
  await assert.rejects(f.receiver.begin({ ...f.input, files: f.input.files.map((file) => ({ ...file, size: 16 * 1024 ** 3 })) }), /16 GiB/)
})

test("does not admit incomplete or corrupt captures", async (t) => {
  const f = await fixture(t)
  const { uploadID } = await f.receiver.begin(f.input)
  await assert.rejects(f.receiver.finish(uploadID), /Incomplete/)
  assert.equal(f.prompts.length, 0)
  await f.receiver.cancel(uploadID)
  const bad = { ...f.input, files: f.input.files.map((file) => ({ ...file, sha256: "0".repeat(64) })) }
  await assert.rejects(sendBundle(bad, f.transport, () => {}), /could not be confirmed/)
  assert.equal(f.prompts.length, 0)
})

test("rejects invalid offsets and chunk sizes", async (t) => {
  const f = await fixture(t)
  const { uploadID } = await f.receiver.begin(f.input)
  const path = "recording.mp4"
  await assert.rejects(f.receiver.chunk({ uploadID, path, offset: 1, data: "eA==" }), /offset/)
  await assert.rejects(f.receiver.chunk({ uploadID, path: "../escape", offset: 0, data: "eA==" }), /manifest/)
  await assert.rejects(f.receiver.chunk({ uploadID, path, offset: 0, data: "!" }), /Invalid/)
  await assert.rejects(f.receiver.chunk({ uploadID, path, offset: 0, data: Buffer.alloc(CHUNK_SIZE + 1).toString("base64") }), /Invalid/)
})

test("interrupted upload is cleaned up without prompting", async (t) => {
  const f = await fixture(t)
  await assert.rejects(sendBundle(f.input, {
    ...f.transport, chunk: async () => { throw new Error("connection lost") },
  }, () => {}), /connection lost/)
  assert.equal(f.prompts.length, 0)
  assert.deepEqual(await readdir(join(f.root, "remote")), [])
})

test("finish is idempotent, including concurrent requests", async (t) => {
  const f = await fixture(t)
  let id = ""
  await sendBundle(f.input, {
    ...f.transport,
    begin: async (input) => { const result = await f.receiver.begin(input); id = result.uploadID; return result },
    finish: async ({ uploadID }) => {
      const [a, b] = await Promise.all([f.receiver.finish(uploadID), f.receiver.finish(uploadID)])
      assert.deepEqual(a, b)
      return a
    },
    cancel: async () => {},
  }, () => {})
  await f.receiver.finish(id)
  assert.equal(f.prompts.length, 1)
})

test("ambiguous prompt failures are not retried or deleted", async (t) => {
  const f = await fixture(t)
  let count = 0
  let id = ""
  const receiver = new Receiver(join(f.root, "failing"), async () => { count++; throw new Error("response lost") })
  await assert.rejects(sendBundle(f.input, {
    begin: async (input) => { const result = await receiver.begin(input); id = result.uploadID; return result },
    chunk: (input) => receiver.chunk(input), finish: ({ uploadID }) => receiver.finish(uploadID), cancel: async () => {},
  }, () => {}), /Check the session/)
  await assert.rejects(receiver.finish(id), /response lost/)
  assert.equal(count, 1)
  await receiver.cancel(id)
  assert.equal((await readdir(join(f.root, "failing"))).filter((name) => name.endsWith(".scrawl")).length, 1)
})

test("expired uploads are removed and cannot be used", async (t) => {
  const f = await fixture(t)
  const { uploadID } = await f.receiver.begin(f.input)
  await f.receiver.expire(Date.now() + 3_600_001)
  await assert.rejects(f.receiver.finish(uploadID), /expired/)
  assert.deepEqual(await readdir(join(f.root, "remote")), [])
})

test("latest uses creation time, skips unfinished captures, and ignores later zoom changes", async (t) => {
  const f = await fixture(t)
  const unfinished = join(f.root, "unfinished.scrawl")
  await mkdir(unfinished)
  await writeFile(join(unfinished, "scrawl.json"), "{}")
  assert.equal(await latestBundle(f.root), f.source)
})

test("uses Scrawl capture-directory override without reading agentHost", async (t) => {
  const f = await fixture(t)
  const configDir = join(f.root, ".config/scrawl")
  await mkdir(configDir, { recursive: true })
  await writeFile(join(configDir, "config.json"), JSON.stringify({ capturesDir: f.source, agentHost: "wrong-host" }))
  assert.equal(await capturesDirectory(f.root, {}), f.source)
  assert.equal(await capturesDirectory(f.root, { SCRAWL_CAPTURES_DIR: f.root }), f.root)
})

test("refuses symlinks, incomplete media, and missing original video", async (t) => {
  const f = await fixture(t)
  await symlink(join(f.source, "audio.wav"), join(f.source, "linked"))
  await assert.rejects(bundleFiles(f.source), /symbolic link/)
  await rm(join(f.source, "linked"))
  await writeFile(join(f.source, ".media-pending"), "")
  await assert.rejects(bundleFiles(f.source), /still transferring/)
  await rm(join(f.source, ".media-pending"))
  await rm(join(f.source, "recording.mp4"))
  await assert.rejects(bundleFiles(f.source), /media is missing/)
})

test("recorded destination uses timeline session, never context.session", () => {
  assert.equal(recordedDestination({ destination: { session: "ses_mac" } }, { session: "ses_phone" }), "ses_phone")
  assert.equal(recordedDestination({}, { context: { session: "ses_unrelated" } }), undefined)
})

test("cancelled send never starts an upload", async (t) => {
  const f = await fixture(t)
  const controller = new AbortController()
  controller.abort()
  await assert.rejects(sendBundle(f.input, f.transport, () => {}, controller.signal), /abort/i)
  assert.equal(f.prompts.length, 0)
})

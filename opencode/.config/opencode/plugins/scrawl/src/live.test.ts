import { test } from "node:test"
import assert from "node:assert/strict"
import { spawn } from "node:child_process"
import { mkdtemp, mkdir, writeFile, rm } from "node:fs/promises"
import { tmpdir } from "node:os"
import { join, resolve } from "node:path"
import { fileURLToPath } from "node:url"
import { OpenCode } from "@opencode/client"
import { CHUNK_SIZE, Scrawl } from "./rpc.ts"
import { bundleFiles } from "./bundle.ts"

// Explicit opt-in: starts an isolated server, never uses or prompts a real session.
test("live OpenCode server loads the plugin and accepts chunked RPC uploads", {
  skip: !process.env.SCRAWL_LIVE_TEST, timeout: 60_000,
}, async (t) => {
  const root = await mkdtemp(join(tmpdir(), "opencode-scrawl-live-"))
  t.after(() => rm(root, { recursive: true, force: true }))
  const config = join(root, "config/opencode")
  await mkdir(config, { recursive: true })
  const plugin = resolve(fileURLToPath(new URL("..", import.meta.url)))
  await writeFile(join(config, "opencode.json"), JSON.stringify({ plugins: [plugin] }))
  let logs = ""
  const child = spawn("opencode", ["serve", "--hostname", "127.0.0.1", "--port", "0"], {
    cwd: root,
    env: {
      ...process.env, OPENCODE_CONFIG_DIR: config,
      XDG_CONFIG_HOME: join(root, "config"), XDG_DATA_HOME: join(root, "data"),
      XDG_STATE_HOME: join(root, "state"), OPENCODE_CONFIG_CONTENT: "{}",
      OPENCODE_PASSWORD: "scrawl-isolated-test", OPENCODE_SERVER_PASSWORD: "scrawl-isolated-test",
    },
    stdio: ["ignore", "pipe", "pipe"],
  })
  t.after(async () => {
    child.kill("SIGTERM")
    if (child.exitCode === null) await new Promise<void>((resolve) => child.once("exit", () => resolve()))
  })
  const url = await new Promise<string>((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error(`Server startup timed out: ${logs}`)), 30_000)
    const read = (data: Buffer) => {
      logs += data.toString()
      const match = logs.match(/http:\/\/127\.0\.0\.1:\d+/)
      if (match) { clearTimeout(timer); resolve(match[0]) }
    }
    child.stdout.on("data", read)
    child.stderr.on("data", read)
    child.once("error", (error) => { clearTimeout(timer); reject(error) })
    child.once("exit", () => { clearTimeout(timer); reject(new Error(`Server exited: ${logs}`)) })
  })
  const client = OpenCode.make({ baseUrl: url, headers: {
    authorization: `Basic ${Buffer.from("opencode:scrawl-isolated-test").toString("base64")}`,
  } })
  const location = { directory: root }
  const session = await client.session.create({ location, title: "Scrawl RPC smoke test" })
  const rpc = client.rpc(Scrawl)
  const source = join(root, "fixture.scrawl")
  await mkdir(source)
  await writeFile(join(source, "scrawl.json"), "{}")
  await writeFile(join(source, "summary.md"), "test")
  const media = Buffer.alloc(CHUNK_SIZE, 71)
  await writeFile(join(source, "recording.mp4"), media)
  const { uploadID } = await rpc.begin({
    source, sessionID: session.id, files: await bundleFiles(source),
  }, { location })
  assert.ok(uploadID)
  const result = await rpc.chunk({ uploadID, path: "summary.md", offset: 0, data: Buffer.from("test").toString("base64") }, { location })
  assert.equal(result.received, 4)
  const large = await rpc.chunk({ uploadID, path: "recording.mp4", offset: 0, data: media.toString("base64") }, { location })
  assert.equal(large.received, CHUNK_SIZE)
  await rpc.cancel({ uploadID }, { location })
  await client.session.remove({ sessionID: session.id })
})

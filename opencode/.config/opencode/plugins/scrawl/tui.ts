import { Plugin } from "@opencode/plugin/tui"
import { readFile } from "node:fs/promises"
import { join } from "node:path"
import { bundleFiles, capturesDirectory, latestBundle, recordedDestination } from "./src/bundle.ts"
import { beginSchema, Scrawl } from "./src/rpc.ts"
import { sendBundle } from "./src/send.ts"

export default Plugin.define({
  id: "scrawl.cli",
  setup(context) {
    let busy = false
    const controller = new AbortController()
    const slot = context.ui.slot({
      append: "app",
      render: () => {
        context.keymap.layer(() => ({
          mode: "global",
          commands: [{
            id: "scrawl.send", title: "Send latest Scrawl capture", group: "Scrawl",
            // No palette entry or keybinding: /scrawl is the only send trigger.
            slash: { name: "scrawl" },
            enabled: () => context.ui.router.current().type === "session",
            async run() {
              if (busy) return
              const route = context.ui.router.current()
              if (route.type !== "session") return
              busy = true
              try {
                await context.data.session.sync(route.sessionID)
                const session = context.data.session.get(route.sessionID)
                if (!session) throw new Error("Current session could not be loaded")
                const location = session.location
                const rpc = context.client.rpc(Scrawl)
                const request = { location, signal: controller.signal }
                const source = await latestBundle(await capturesDirectory())
                const manifest = JSON.parse(await readFile(join(source, "scrawl.json"), "utf8"))
                let timeline: unknown
                try { timeline = JSON.parse(await readFile(join(source, "timeline.json"), "utf8")) } catch (error) {
                  if ((error as NodeJS.ErrnoException).code !== "ENOENT") throw error
                }
                const destination = recordedDestination(manifest, timeline)
                if (destination && destination !== route.sessionID) {
                  const confirmed = await context.ui.dialog.confirm({
                    title: "Send to this session instead?",
                    message: `This capture was addressed to ${destination}. Send the full capture to the current session on the connected server?`,
                    label: { confirm: "Send", cancel: "Cancel" },
                  })
                  if (!confirmed) return
                }
                context.ui.toast.show({ message: "Preparing full Scrawl capture…", variant: "info" })
                const input = beginSchema.parse({ sessionID: route.sessionID, source, files: await bundleFiles(source) })
                let lastProgress = 0
                await sendBundle(input, {
                  begin: (input) => rpc.begin(input, request),
                  chunk: (input) => rpc.chunk(input, request),
                  finish: (input) => rpc.finish(input, request),
                  cancel: (input) => rpc.cancel(input, { location, signal: AbortSignal.timeout(5000) }),
                }, (sent, total) => {
                  if (Date.now() - lastProgress < 2000) return
                  lastProgress = Date.now()
                  context.ui.toast.show({ message: `Uploading Scrawl: ${Math.round(sent / total * 100)}% (${Math.ceil(sent / 1024 ** 2)}/${Math.ceil(total / 1024 ** 2)} MiB)`, variant: "info" })
                }, controller.signal)
                context.ui.toast.show({ message: "Full Scrawl capture queued in this session", variant: "success" })
              } catch (error) {
                context.ui.toast.show({
                  message: `Scrawl: ${error instanceof Error ? error.message : String(error)}. The Scrawl server plugin must also be installed on the connected server.`,
                  variant: "error", duration: 10_000,
                })
              } finally { busy = false }
            },
          }],
        }))
        return null
      },
    })
    return () => { controller.abort(); slot() }
  },
})

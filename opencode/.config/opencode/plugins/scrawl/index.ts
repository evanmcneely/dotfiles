import { Plugin } from "@opencode/plugin"
import { homedir } from "node:os"
import { join } from "node:path"
import { Receiver } from "./src/receiver.ts"
import { Scrawl } from "./src/rpc.ts"

export default Plugin.define({
  id: "scrawl",
  async setup(ctx) {
    const root = join(process.env.XDG_DATA_HOME ?? join(homedir(), ".local/share"), "opencode/scrawl/captures")
    const receiver = new Receiver(root, (input) => ctx.session.prompt(input))
    await ctx.rpc.register(Scrawl, {
      begin: async (input) => {
        const session = await ctx.session.get({ sessionID: input.sessionID })
        if (session.location.directory !== ctx.location.directory) throw new Error("Scrawl session is in a different location")
        return receiver.begin(input)
      },
      chunk: (input) => receiver.chunk(input),
      finish: (input) => receiver.finish(input.uploadID),
      cancel: (input) => receiver.cancel(input.uploadID),
    })
    const timer = setInterval(() => void receiver.expire().catch(console.error), 60_000)
    timer.unref()
    return () => clearInterval(timer)
  },
})

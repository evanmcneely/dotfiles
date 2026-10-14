import { execFile } from "node:child_process"
import { Plugin } from "@opencode/plugin/tui"

function shellQuote(value: string) {
  return "'" + value.replaceAll("'", "'\"'\"'") + "'"
}

export default Plugin.define({
  id: "nvim-worktree",
  setup(context) {
    // Register inside the UI tree, where Keymap.Provider is available.
    return context.ui.slot({
      append: "app",
      render: () => {
        context.keymap.layer(() => ({
          mode: "global",
          commands: [
            {
              id: "nvim-worktree.copy",
              title: "Copy Neovim worktree command",
              group: "Session",
              bind: "<leader>v",
              palette: true,
              enabled: () => context.ui.router.current().type === "session",
              async run() {
                const route = context.ui.router.current()
                if (route.type !== "session") return

                try {
                  // Refresh on each press so moving a session uses its latest directory.
                  await context.data.session.sync(route.sessionID)
                  const session = context.data.session.get(route.sessionID)
                  if (!session) throw new Error("The current session could not be loaded")
                  const directory = session.location.directory
                  if (!directory) throw new Error("The session has no working directory")

                  // Only the subshell changes directory; the parent shell stays put.
                  const command = `(cd ${shellQuote(directory)} && nvim .)`
                  await new Promise<void>((resolve, reject) => {
                    const copy = execFile("/usr/bin/pbcopy", (error) => (error ? reject(error) : resolve()))
                    copy.stdin?.on("error", reject)
                    copy.stdin?.end(command)
                  })

                  context.ui.toast.show({ message: "Neovim worktree command copied", variant: "success" })
                } catch (error) {
                  context.ui.toast.show({
                    message: `Could not copy Neovim command: ${error instanceof Error ? error.message : String(error)}`,
                    variant: "error",
                  })
                }
              },
            },
          ],
          bindings: ["nvim-worktree.copy"],
        }))
        return null
      },
    })
  },
})

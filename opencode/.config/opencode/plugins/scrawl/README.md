# OpenCode Scrawl

Run `/scrawl` in an open OpenCode V2 terminal session to send the latest completed
local capture to **that session on the connected server**. Nothing is sent at
startup, on prompts, or on a timer. There is no send keybinding or palette action.

## Install

Install this directory on **both the client Mac and the OpenCode server**:

```sh
cd ~/.config/opencode/plugins/scrawl
npm ci --ignore-scripts
```

OpenCode discovers `index.ts` (server receiver) and `tui.ts` (local command) in its
global plugins directory. Restart the terminal client and reload/restart the
server after installation. The server must have the same plugin version.

Alternatively load the directory explicitly in `opencode.json` on the server:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugins": ["/absolute/path/to/scrawl"]
}
```

For an explicit client-only registration, add the same directory to `plugins` in
the **client's** `cli.json`. Keep the receiver installed on the server too.

Scrawl's GUI creates the capture; its local CLI is not required. The remote
`scrawl` CLI must be on the agent's PATH for `zoom`, `frames`, and `export`.
Those commands also require Scrawl's platform support and helper/media tools.
This plugin does not install or launch Scrawl.

## Behavior

- Finds captures using `SCRAWL_CAPTURES_DIR`, then `capturesDir` in
  `~/.config/scrawl/config.json`, then Scrawl's normal captures directory.
- Chooses by manifest creation time, not directory modification time. Incomplete
  captures are skipped. Active media transfers, symlinks, and missing referenced
  original video/audio are refused rather than claiming a full transfer.
- Transfers all regular bundle files, including video, audio, full-size frames,
  and existing zoom/export output. Scrawl delivery/transfer marker files are
  excluded so the receiver doesn't resend the capture or wait for nonexistent work.
- Uses the current authenticated OpenCode client connection, never `agentHost`,
  SSH, `scrawl send`, or a "most recent" server session. Switching tabs during
  upload does not change its destination.
- Asks before sending a recording addressed to a different session.
- Uploads in 512 KiB binary chunks encoded as base64, with bounded memory. The
  server limits transfers to 16 GiB, 20,000 files, and four active uploads per
  plugin instance. Every file is SHA-256 checked before admission.
- Stages files privately, atomically publishes the complete `.scrawl` directory,
  rewrites local bundle paths in the summary/manifest, and queues the summary
  with the server-side contact-sheet attachment. Original local files are untouched.
- Repeated finish requests reuse the same result instead of sending twice.
  Delivery errors after finalization are reported as unconfirmed: check the
  session before invoking `/scrawl` again. A new invocation is an explicit resend.
- Uploads interrupted before finalization are removed where possible. Inactive
  uploads expire after one hour; crash-left staging folders after 24 hours.

Completed remote bundles live in
`$XDG_DATA_HOME/opencode/scrawl/captures` (default
`~/.local/share/opencode/scrawl/captures`). They are kept after delivery and after
ambiguous delivery failures, so queued prompts never lose their media. These are
outside Scrawl's normal capture-retention folder: remove old transferred bundles
manually when no longer needed. No remote media is automatically deleted.

## Verify

```sh
npm run typecheck
npm test
SCRAWL_LIVE_TEST=1 node --test src/live.test.ts
```

The opt-in live test starts an isolated OpenCode server, creates a temporary
session, transfers test chunks through the real authenticated RPC client, cancels
the upload, and deletes the test session. It never submits a model prompt or
sends your captures.

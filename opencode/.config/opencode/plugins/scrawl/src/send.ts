import { open } from "node:fs/promises"
import { join } from "node:path"
import { CHUNK_SIZE, type Begin } from "./rpc.ts"

export interface Transport {
  begin(input: Begin): Promise<{ uploadID: string }>
  chunk(input: { uploadID: string; path: string; offset: number; data: string }): Promise<{ received: number }>
  finish(input: { uploadID: string }): Promise<{ directory: string }>
  cancel(input: { uploadID: string }): Promise<unknown>
}

export async function sendBundle(input: Begin, transport: Transport, progress: (sent: number, total: number) => void, signal?: AbortSignal) {
  signal?.throwIfAborted()
  const { uploadID } = await transport.begin(input)
  const total = input.files.reduce((sum, file) => sum + file.size, 0)
  let sent = 0
  let finishing = false
  try {
    const buffer = Buffer.alloc(CHUNK_SIZE)
    for (const file of input.files) {
      signal?.throwIfAborted()
      const handle = await open(join(input.source, file.path), "r")
      try {
        let offset = 0
        while (offset < file.size) {
          signal?.throwIfAborted()
          const { bytesRead } = await handle.read(buffer, 0, Math.min(buffer.length, file.size - offset), offset)
          if (!bytesRead) throw new Error(`Capture changed during upload: ${file.path}`)
          const result = await transport.chunk({ uploadID, path: file.path, offset, data: buffer.subarray(0, bytesRead).toString("base64") })
          if (result.received !== offset + bytesRead) throw new Error("Unexpected Scrawl upload offset")
          offset += bytesRead
          sent += bytesRead
          progress(sent, total)
        }
        if ((await handle.stat()).size !== file.size) throw new Error(`Capture changed during upload: ${file.path}`)
      } finally { await handle.close() }
    }
    signal?.throwIfAborted()
    finishing = true
    return await transport.finish({ uploadID })
  } catch (error) {
    if (finishing) throw new Error("Scrawl delivery could not be confirmed. Check the session before sending again.", { cause: error })
    throw error
  } finally {
    await transport.cancel({ uploadID }).catch(() => {})
  }
}

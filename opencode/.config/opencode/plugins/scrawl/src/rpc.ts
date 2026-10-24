import { Rpc } from "@opencode/plugin/rpc"
import { z } from "zod"

export const CHUNK_SIZE = 512 * 1024
export const MAX_BYTES = 16 * 1024 ** 3
export const fileSchema = z.object({
  path: z.string().min(1).max(1024),
  size: z.number().int().min(0).max(MAX_BYTES),
  sha256: z.string().regex(/^[a-f0-9]{64}$/),
})
export const beginSchema = z.object({
  sessionID: z.string().regex(/^ses[\w-]+$/),
  source: z.string().min(1).max(4096),
  files: z.array(fileSchema).min(1).max(20000),
})
export type Begin = z.infer<typeof beginSchema>
export type BundleFile = z.infer<typeof fileSchema>
export const Scrawl = Rpc.define({
  id: "scrawl",
  events: {},
  methods: {
    begin: { input: beginSchema, output: z.object({ uploadID: z.string() }) },
    chunk: {
      input: z.object({
        uploadID: z.string(), path: z.string(), offset: z.number().int().min(0),
        data: z.string().max(Math.ceil(CHUNK_SIZE / 3) * 4),
      }),
      output: z.object({ received: z.number() }),
    },
    finish: {
      input: z.object({ uploadID: z.string() }),
      output: z.object({ directory: z.string() }),
    },
    cancel: { input: z.object({ uploadID: z.string() }), output: z.object({}) },
  },
})

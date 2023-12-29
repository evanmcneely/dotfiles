return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = {
      { "<leader>gd", "<cmd>DiffviewToggleFiles<cr>", desc = "Diff View Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
    },
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      -- overrides default keymap
      { "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
    },
  },
}

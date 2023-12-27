return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  keys = {
    { "<leader>et", "<cmd>NvimTreeToggle<cr>", desc = "Toggle" },
    { "<leader>er", "<cmd>NvimTreeRefresh<cr>", desc = "Refresh" },
    { "<leader>ef", "<cmd>NvimTreeFindFile<cr>", desc = "Find file" },
    { "<leader>en", "<cmd>NvimTreeFocus<cr>", desc = "Focus" },
    { "<leader>ec", "<cmd>NvimTreeClose<cr>", desc = "Close" },
  },
  config = function()
    require("nvim-tree").setup {
      -- disable_netrw = true,
      -- hijack_netrw = true,
      -- open_on_tab = false,
      -- hijack_cursor = true,
      -- update_cwd = true,
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      -- system_open = {
      --   cmd = nil,
      --   args = {},
      -- },
      view = {
        width = 40,
        side = "left",
      },
    }
  end,
}

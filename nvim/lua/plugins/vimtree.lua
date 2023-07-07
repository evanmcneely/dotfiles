local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings

  -- local function opts(desc)
  --   return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  -- end


  -- custom mappings
  -- vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
  -- vim.keymap.set("n", "L", vsplit_preview, opts "Preview")
  -- vim.keymap.set("n", "h", api.tree.close_node, opts "Close")
  -- vim.keymap.set("n", "H", collapse_all, opts "Collapse all")
  -- vim.keymap.set("n", "t", swap_then_open_tab, opts "Swap then open tab")
end

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
      on_attach = on_attach,
      disable_netrw = true,
      hijack_netrw = true,
      open_on_tab = false,
      hijack_cursor = true,
      update_cwd = true,
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      system_open = {
        cmd = nil,
        args = {},
      },
      view = {
        width = 40,
        side = "left",
      },
    }
  end,
}

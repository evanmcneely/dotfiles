-- local function edit_or_open()
--   -- open as vsplit on current node
--   local action = "edit"
--   local node = lib.get_node_at_cursor()

--   -- Just copy what's done normally with vsplit
--   if node.link_to and not node.nodes then
--     require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
--     view.close() -- Close the tree if file was opened
--   elseif node.nodes ~= nil then
--     lib.expand_or_collapse(node)
--   else
--     require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
--     view.close() -- Close the tree if file was opened
--   end
-- end

local function collapse_all()
  require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function vsplit_preview()
  local lib = require "nvim-tree.lib"
  local view = require "nvim-tree.view"
  -- open as vsplit on current node
  local action = "vsplit"
  local node = lib.get_node_at_cursor()

  -- Just copy what's done normally with vsplit
  if node.link_to and not node.nodes then
    require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
  elseif node.nodes ~= nil then
    lib.expand_or_collapse(node)
  else
    require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
  end

  -- Finally refocus on tree if it was lost
  view.focus()
end

local swap_then_open_tab = function()
  local lib = require "nvim-tree.lib"
  local api = require "nvim-tree.api"

  local node = lib.get_node_at_cursor()
  vim.cmd "wincmd l"
  api.node.open.tab(node)
end

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

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
      ignore_ft_on_setup = {},
      -- auto_close = true,
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
        -- auto_resize = false,
      },
    }
  end,
}

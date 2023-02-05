-- File explorer
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
    local lib = require "nvim-tree.lib"
    local view = require "nvim-tree.view"
    local api = require "nvim-tree.api"

    local function collapse_all()
      require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
    end

    local function edit_or_open()
      -- open as vsplit on current node
      local action = "edit"
      local node = lib.get_node_at_cursor()

      -- Just copy what's done normally with vsplit
      if node.link_to and not node.nodes then
        require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
        view.close() -- Close the tree if file was opened
      elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)
      else
        require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
        view.close() -- Close the tree if file was opened
      end
    end

    local function vsplit_preview()
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
      local node = lib.get_node_at_cursor()
      vim.cmd "wincmd l"
      api.node.open.tab(node)
    end

    local function change_root_to_global_cwd()
      local global_cwd = vim.fn.getcwd(-1, -1)
      api.tree.change_root(global_cwd)
    end

    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd("edit " .. file.fname)
    end)

    require("nvim-tree").setup {
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
        mappings = {
          custom_only = false,
          list = {
            { key = "l", action = "edit", action_cb = edit_or_open },
            { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
            { key = "h", action = "close_node" },
            { key = "H", action = "collapse_all", action_cb = collapse_all },
            { key = "t", action = "swap_then_open_tab", action_cb = swap_then_open_tab },
            { key = "<C-C>", action = "global_cwd", action_cb = change_root_to_global_cwd },
          },
        },
      },
    }
  end,
}

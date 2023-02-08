return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- local groups = require "bufferline.groups"

    local opts = {
      options = {
        mode = "tabs", -- tabs or buffers
        numbers = "buffer_id",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        separator_style = "slant" or "padded_slant",
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "center",
          },
        },
        custom_filter = function(buf_number, _)
          local tab_num = 0
          for _ in pairs(vim.api.nvim_list_tabpages()) do
            tab_num = tab_num + 1
          end

          if tab_num > 1 then
            if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
              return true
            end
          else
            return true
          end
        end,
        sort_by = function(buffer_a, buffer_b)
          local mod_a = ((vim.loop.fs_stat(buffer_a.path) or {}).mtime or {}).sec or 0
          local mod_b = ((vim.loop.fs_stat(buffer_b.path) or {}).mtime or {}).sec or 0
          return mod_a > mod_b
        end,
      },
      -- keys = {
      -- { "<leader>bP", "<cmd>BufferLineTogglePin<cr>", desc = "Pin" },
      -- { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
      -- { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev" },
      -- { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close Right" },
      -- { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Left" },
      -- { "<leader>bcl", "<cmd>BufferLineCloseBuffersLeft<cr>", desc = "Close Buffers Left" },
      -- { "<leader>bcr", "<cmd>BufferLineCloseBuffersRight<cr>", desc = "Close Buffers Right" },
      -- { "<leader>bcc", "<cmd>BufferLineCloseAllButCurrent<cr>", desc = "Close All But Current" },
      -- { "<leader>bcv", "<cmd>BufferLineCloseAllButVisible<cr>", desc = "Close All But Visible" },
      -- { "<leader>bcp", "<cmd>BufferLineCloseAllButPinned<cr>", desc = "Close All But Pinned" },
      -- { "<leader>bgc", "<cmd>BufferLineGroupClose<tab><cr>", desc = "Group Close" },
      -- { "<leader>bgt", "<cmd>BufferLineGroupToggle<tab><cr>", desc = "Group Toggle" },
      --   `require('bufferline').group_action` API.
      -- },
      -- groups = {
      --   options = {
      --     toggle_hidden_on_enter = true,
      --   },
      --   items = {
      --     groups.builtin.pinned:with { icon = "" },
      --     groups.builtin.ungrouped,
      --     {
      --       name = "Tests ",
      --       auto_close = true,
      --       matcher = function(buf)
      --         return buf.filename:match "%.test" or buf.filename:match "%.spec" or buf.filename:match "%dap%"
      --       end,
      --       separator = {
      --         style = groups.separator.buffer,
      --       },
      --     },
      --     {
      --       name = "Docs ",
      --       auto_close = true,
      --       matcher = function(buf)
      --         return buf.filename:match "%.md" or buf.filename:match "%.txt"
      --       end,
      --       separator = {
      --         style = groups.separator.buffer,
      --       },
      --     },
      --     {
      --       name = "Config ",
      --       auto_close = true,
      --       matcher = function(buf)
      --         return buf.filename:match "%.yaml"
      --           or buf.filename:match "%.toml"
      --           or buf.filename:match "%.lock"
      --           or buf.filename:match "%-lock%"
      --           or buf.filename:match "package.json"
      --           or buf.filename:match ".gitignore"
      --           or buf.filename:match "%.cfg"
      --       end,
      --       separator = {
      --         style = groups.separator.buffer,
      --       },
      --     },
      --   },
      -- },
    }

    require("bufferline").setup(opts)
  end,
}

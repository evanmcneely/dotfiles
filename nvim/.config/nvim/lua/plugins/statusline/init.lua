return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "folke/noice.nvim",
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require "lualine_require"
    lualine_require.require = require
    local components = require "plugins.statusline.components"

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        component_separators = { left = "  ", right = "" },
        section_separators = "",
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          components.mode,
          components.branch,
          components.diff,
          components.filename,
          components.diagnostics,
        },
        lualine_x = {
          components.noice_mode,
          components.noice_command,
          components.shift_width,
          components.progress,
          "filetype",
        },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", "oil" },
    }

    return opts
  end,
}

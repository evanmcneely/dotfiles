return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local components = require "plugins.statusline.components"

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { right = "│", left = "│" },
          section_separators = {},
          disabled_filetypes = {
            statusline = {
              "alpha",
              "lazy",
              -- "NeogitStatus",
              -- "NeogitCommitPopup",
              -- "COMMIT_EDITMSG",
            },
            winbar = {
              "help",
              "alpha",
              "lazy",
            },
          },
          -- always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            components.git_repo,
          },
          lualine_b = {
            components.branch,
          },
          lualine_c = {
            components.diff,
          },
          lualine_x = {
            components.diagnostics,
          },
          lualine_y = {
            "filetype",
            components.lsp_client,
          },
          lualine_z = {
            "progress",
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      }
    end,
  },
}

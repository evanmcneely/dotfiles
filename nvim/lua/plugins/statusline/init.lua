return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local components = require "plugins.statusline.components"

      require("lualine").setup {
        options = {
          icoes_enabled = true,
          theme = "auto",
          component_separators = { right = "|" },
          section_separators = {},
          disabled_filetypes = {
            statusline = {
              "alpha",
              "lazy",
              "NeogitStatus",
              "NeogitCommitPopup",
              "COMMIT_EDITMSG",
            },
            winbar = {
              "help",
              "alpha",
              "lazy",
              "NeogitStatus",
              "NeogitCommitPopup",
              "COMMIT_EDITMSG",
            },
          },
          always_divide_middle = true,
          globalstatus = true,
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = { components.git_repo_exp, components.branch, components.diff },
          lualine_c = {
            "diagnostics",
            components.separator,
            components.lsp_client,
          },
          lualine_x = {
            components.filename,
            components.window,
            components.spaces,
            "encoding",
            "fileformat",
            "progress",
          },
          lualine_y = {},
          lualine_z = { "location" },
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
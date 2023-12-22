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
          lualine_a = { "mode" },
          lualine_b = {
            components.git_repo,
          },
          lualine_c = {
            components.branch,
            components.diff,
          },
          lualine_x = {
            components.diagnostics,
            components.lsp_client,
          },
          lualine_y = {
            components.codeium,
            components.spaces,
            "filetype",
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

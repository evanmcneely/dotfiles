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
          component_separators = { right = "|", left = "|" }, -- │
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
            components.filename,
          },
          lualine_x = {
            components.diagnostics,
            components.lsp_client,
          },
          lualine_y = { "filetype" },
          lualine_z = {
            "progress",
          },
        },
        winbar = {
          -- lualine_c = { components.filename, components.diff },
          -- lualine_x = { components.diagnostics },
        },
        inactive_winbar = {
          -- lualine_c = { components.filename },
          -- lualine_x = { components.diagnostics },
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      }
    end,
  },
}

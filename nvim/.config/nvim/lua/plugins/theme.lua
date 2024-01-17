return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    -- enabled = false,
    priority = 1000,
    opts = {
      style = "deep",
    },
  },
  {
    "catppuccin/nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      local palette = require "nordic.colors"
      local opts = {
        bold_keywords = true,
        telescope = {
          style = "classic",
        },
        override = {
          TelescopePromptTitle = { fg = palette.orange.dim },
          TelescopeResultsTitle = { fg = palette.orange.dim },
          TelescopePreviewTitle = { fg = palette.blue2 },
          TelescopePromptBorder = { fg = palette.orange.dim },
          TelescopeResultsBorder = { fg = palette.orange.dim },
          TelescopePreviewBorder = { fg = palette.blue2 },
          MatchParen = { underline = false },
          -- Normal = { bg = "#1c1f27" },
          -- NormalSB = { bg = "red" },
          -- SignColumnSB = { bg = "#1c1f27" },
        },
      }
      return opts
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },

  -- Configure LazyVim colorscheme with this
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordic",
    },
  },
}

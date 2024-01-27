return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    enabled = false,
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
    enabled = false,
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
          TelescopePromptTitle = { fg = palette.cyan.dim },
          TelescopeResultsTitle = { fg = palette.cyan.dim },
          TelescopePreviewTitle = { fg = palette.cyan.dim },
          TelescopePromptBorder = { fg = palette.cyan.dim },
          TelescopeResultsBorder = { fg = palette.cyan.dim },
          TelescopePreviewBorder = { fg = palette.cyan.dim },
          -- MatchParen = { underline = false },
          PmenuSel = { fg = palette.yellow.dim, bg = palette.black0 }, -- cmp menu
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
      -- colorscheme = "nordic",
    },
  },
}

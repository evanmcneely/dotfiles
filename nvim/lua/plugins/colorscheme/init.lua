return {
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    config = function()
      require("styler").setup {
        themes = {
          help = { colorscheme = "gruvbox" },
        },
      }
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require "tokyonight"
      tokyonight.setup { style = "storm" }
      tokyonight.load()
    end,
  },
  {
    "catppuccin/nvim",
    -- lazy = false,
    name = "catppuccin",
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    -- priority = 1000,
    config = function()
      local gruvbox = require "gruvbox"
      gruvbox.setup {
        contrast = "hard",
      }
      -- gruvbox.load()
    end,
  },
}

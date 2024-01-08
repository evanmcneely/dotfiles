return {
  { "ellisonleao/gruvbox.nvim", enabled = false, priority = 1000, config = true },
  { "navarasu/onedark.nvim", enabled = false, priority = 1000 },
  { "catppuccin/nvim", priority = 1000 },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },

  -- Configure LazyVim colorscheme
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "onedark",
  --   },
  -- },

  -- use colors for specific filestypes
  {
    "folke/styler.nvim",
    opts = {
      themes = {
        markdown = { colorscheme = "catppuccin-macchiato" },
        help = { colorscheme = "catppuccin-mocha" },
      },
    },
  },
}

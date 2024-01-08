return {
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
  { "navarasu/onedark.nvim", enabled = false, priority = 1000 },
  { "catppuccin/nvim", priority = 1000 },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },

  -- Configure LazyVim colorscheme with this
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "onedark",
  --   },
  -- },

  -- use colors for specific filestypes
  {
    "folke/styler.nvim",
    enabled = false, -- causes "unthemed content"
    event = "VeryLazy", -- required
    opts = {
      themes = {
        markdown = { colorscheme = "catppuccin" },
        help = { colorscheme = "gruvbox" },
      },
    },
  },
}

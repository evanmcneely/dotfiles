return {
  "glepnir/lspsaga.nvim",
  -- enabled = false,
  event = "BufReadPost",
  config = function()
    require("lspsaga").setup {
      lightbulb = { enable = false },
      symbol_in_winbar = {
        enable = false,
        -- separator = ' ',
        hide_keyword = true,
        show_file = true,
        folder_level = 3,
      },
    }
  end,
}

return {
  "akinsho/toggleterm.nvim",
  keys = { [[<C-\>]] },
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    size = 110,
    hide_numbers = true,
    open_mapping = [[<C-\>]],
    shade_filetypes = {},
    start_in_insert = true,
    persist_size = true,
    direction = "vertical",
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    },
  },
}

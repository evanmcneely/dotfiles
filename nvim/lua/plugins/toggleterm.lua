return {
  "akinsho/toggleterm.nvim",
  keys = { [[<C-\>]] },
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    size = 20,
    hide_numbers = true,
    open_mapping = [[<C-\>]],
    shade_filetypes = {},
    -- shade_terminals = true,
    -- shading_factor = -30,
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal",
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    },
  },
}

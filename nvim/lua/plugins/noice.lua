return {
  "folke/noice.nvim",
  lazy = false,
  -- enabled = false,
  opts = {
    lsp = {
      progress = {
        enabled = true,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    signature = {
      enabled = false,
    },
    cmdline = {
      enabled = false,
      view = "mini",
    },
    popupmenu = {
      enabled = false,
      view = "mini",
    },
    messages = {
      enabled = false,
    },
  },
  --stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>sml", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>smh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sma", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward" },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward"},
  },
}

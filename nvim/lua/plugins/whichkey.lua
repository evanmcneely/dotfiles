return {
  -- VS Code like command palette for functions, keymaps, commands, etc.
  {
    "mrjones2014/legendary.nvim",
    -- enabled = false,
    keys = {
      { "<leader>hc", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      which_key = { auto_register = true },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require "which-key"
      wk.setup {
        show_help = true,
        plugins = { spelling = true },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
      }
      wk.register({
        mode = { "n", "v" },
        w = {
          name = "+Save",
          f = { require("plugins.lsp.format").toggle, "Format on save" },
          w = { "<cmd>update!<CR>", "Save" },
        },
        q = {
          name = "+Quit",
          q = {
            function()
              require("utils").smart_quit()
            end,
            "Quit",
          },
          t = { "<cmd>tabclose<cr>", "Close Tab" },
        },
        b = { name = "+Buffer", c = { name = "+Close" }, g = { name = "+Group" } },
        d = { name = "+Debug" },
        f = { name = "+File" },
        h = { name = "+Help" },
        g = { name = "+Git", h = { name = "+Hunk" }, t = { name = "+Toggle" } },
        p = { name = "+Project" },
        t = { name = "+Test", N = { name = "Neotest" }, o = { "Overseer" } },
        v = { name = "+View" },
        e = { name = "+Explorer" },
        a = { name = "+AI" },
        z = { name = "+System" },
        s = {
          name = "+Search",
          c = { require("utils.coding").cht, "Cheatsheets" },
          s = { require("utils.coding").stack_overflow, "Stack Overflow" },
          i = { require("utils.term").interactive_cheatsheet_toggle, "Interactive cheatsheet" },
          m = { name = "+Messages" },
        },
        c = {
          name = "+Code",
          g = { name = "+Annotation" },
          x = {
            name = "Swap Next",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
          X = {
            name = "Swap Previous",
            f = "Function",
            p = "Parameter",
            c = "Class",
          },
        },
        u = {
          name = "+Utils",
          d = { require("utils.term").docker_client_toggle, "lazydocker" },
        },
      }, { prefix = "<leader>" })
    end,
  },
}

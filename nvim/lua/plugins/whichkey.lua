return {
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
        a = { name = "+AI" },
        c = {
          name = "+Code",
          g = { name = "+Annotation" },
          x = { name = "Swap Next", f = "Function", p = "Parameter", c = "Class" },
          X = { name = "Swap Previous", f = "Function", p = "Parameter", c = "Class" },
          t = { name = "+Trouble" },
        },
        e = { name = "+Explore" },
        g = { name = "+Git", h = { name = "+Hunk" } },
        s = { name = "+Search" },
        t = { name = "+Test" },
        l = { name = "+LSP", M = {"<cmd>Mason<cr>", "Mason"} },
        u = {
          name = "+Utils",
          d = { require("utils.term").docker_client_toggle, "lazydocker" },
          l = { require("utils.term").lazygit_toggle, "lazygit" },
          v = { "<cmd>ToggleTerm direction=vertical size=130<cr>", "Vertical Terminal" },
          h = { '<cmd>ToggleTerm direction=horizontal size=20"<cr>', "Horizontal Terminal" },
          o = { name = "+Overseer" },
        },
        z = {
          name = "+System",
          f = { require("plugins.lsp.format").toggle, "Format on save" },
          w = {
            name = "+Save",
            w = { "<cmd>update!<CR>", "Save" },
          },
          q = {
            name = "+Quit",
            q = { require("utils").smart_quit, "Quit" },
            t = { "<cmd>tabclose<cr>", "Close Tab" },
          },
        },
      }, { prefix = "<leader>" })
    end,
  },
}

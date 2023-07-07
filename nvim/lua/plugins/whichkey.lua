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
        b = { name = "+Buffer", c = { name = "+Close" }, g = { name = "+Group" } },
        d = { name = "+Debug" },
        c = {
          name = "+Code",
          g = { name = "+Annotation" },
          x = { name = "Swap Next", f = "Function", p = "Parameter", c = "Class" },
          X = { name = "Swap Previous", f = "Function", p = "Parameter", c = "Class" },
        },
        e = { name = "+Explorer" },
        f = { name = "+File" },
        g = { name = "+Git", h = { name = "+Hunk" } },
        h = { name = "+Help" },
        j = { name = "+Jump" },
        -- m = { name = "+Messages" },
        -- n = { name = "+Notes" },
        -- p = { name = "+Project" },
        q = {
          name = "+Quit",
          --stylua: ignore 
          q = { require("utils").smart_quit, "Quit" },
          t = { "<cmd>tabclose<cr>", "Close Tab" },
        },
        s = { name = "+Search" },
        t = { name = "+Test", N = { name = "Neotest" }, o = { "Overseer" } },
        u = {
          name = "+Utils",
          d = { require("utils.term").docker_client_toggle, "lazydocker" },
          l = { require("utils.term").lazygit_toggle, "lazygit" },
          v = { '<cmd>ToggleTerm direction=vertical size=110<cr>', "Vertical Terminal" },
          h = { '<cmd>ToggleTerm direction=horizontal size=20"<cr>', "Horizontal Terminal" },
        },
        w = {
          name = "+Save",
          f = { require("plugins.lsp.format").toggle, "Format on save" },
          w = { "<cmd>update!<CR>", "Save" },
        },
        z = { name = "+System" },
      }, { prefix = "<leader>" })
    end,
  },
}

return {
  -- replate which key keymaps
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>e"] = { name = "+explore" },
        ["<leader>g"] = { name = "+git", h = { name = "+hunk" } },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>z"] = {
          name = "+system",
          L = { "<cmd>Lazy<cr>", "Lazy" },
          m = { "<cmd>Mason<cr>", "Mason" },
          l = { "<cmd>LspInfo<cr>", "Lsp info" },
          n = { name = "+noice" },
        },
      },
    },
  },

  -- replace all NeoTree keymaps with my own
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function()
      return {
        { "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "Files" },
        { "<leader>eb", "<cmd>Neotree buffers<cr>", desc = "Buffers" },
        { "<leader>en", "<cmd>Neotree action=focus<cr>", desc = "Explorer focus" },
        { "<leader>es", "<cmd>Neotree show<cr>", desc = "Explorer show" },
        { "<leader>ec", "<cmd>Neotree close<cr>", desc = "Explorer close" },
      }
    end,
  },

  -- replace all Telescope keymaps with my own
  {
    "nvim-telescope/telescope.nvim",
    keys = function()
      return {
        { "<leader><leader>", "<cmd>Telescope git_files theme=dropdown previewer=false<cr>", desc = "Find Files" },
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>sb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
        {
          "<leader>sb",
          function()
            require("telescope.builtin").current_buffer_fuzzy_find()
          end,
          desc = "Buffer",
        },
      }
    end,
  },

  -- same keymaps but under <leader>z
  {
    "folke/noice.nvim",
    keys = function()
      -- stylua: ignore
      return {
        { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
        { "<leader>znl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
        { "<leader>znh", function() require("noice").cmd("history") end, desc = "Noice History" },
        { "<leader>zna", function() require("noice").cmd("all") end, desc = "Noice All" },
        { "<leader>znd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
        { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
        { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
      }
    end,
  },
}

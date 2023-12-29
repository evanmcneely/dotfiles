return {
  -- better repeat on .
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- easily open and join statements to multiple and single lines
  { "AndrewRadev/splitjoin.vim", event = "BufReadPost" },

  -- add marks to sign column
  { "kshenoy/vim-signature", event = "BufReadPre" },

  -- tabout of parentheses and stuff
  {
    "abecodes/tabout.nvim",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("tabout").setup {}
    end,
  },

  -- best auto pairirng of parentheses I've found
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end,
  },

  -- navigate undo/redo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>eu", vim.cmd.UndotreeToggle, desc = "Undotree" } },
  },

  -- git stuff
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "status" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "push" },
    },
  },

  -- really just want the merge conflict resolution tool
  {
    "tpope/vim-fugitive",
    cmd = "Gdiff",
    keys = {
      { "<leader>gd", "<cmd>Gdiff<cr>", desc = "conflict" },
      { "<leader>gu", "<cmd>diffget //2<cr>", desc = "conflict resolve left" },
      { "<leader>gh", "<cmd>diffget //3<cr>", desc = "conflict resolve right" },
    },
  },
}

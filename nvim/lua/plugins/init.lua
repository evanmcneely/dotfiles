return {
  -- helper plugins
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",

  -- better repeat with .
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- dev icons
  "nvim-tree/nvim-web-devicons",

  -- enter :{number} to peek view of line number in buffer
  { "nacro90/numb.nvim", event = "BufReadPre", config = true },

  -- adds indentation guides to all lines (including empty lines)
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      vim.opt.list = true
      require("indent_blankline").setup {
        show_current_context = true,
      }
    end,
  },

  -- Ui improvements
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { relative = "editor" },
      select = {
        backend = { "telescope", "fzf", "builtin" },
      },
    },
  },

  -- nvim messages as popups
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -- increment and decrement things easily
  {
    "monaqa/dial.nvim",
    event = "BufReadPre",
    keys = { "<C-a>", "<C-x>", { "<C-a>", "v" }, { "<C-x>", "v" }, { "g<C-a>", "v" }, { "g<C-x>", "v" } },
    -- stylua: ignore
    init = function()
      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
     end,
  },

  -- Comment stuff out
  { "tpope/vim-commentary", event = "BufReadPre" },
  {
    "numToStr/Comment.nvim",
    enabled = false,
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = { "gc", "gcc", "gbc" },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
      require("Comment").setup(opts)
    end,
  },

  -- complete parens
  {
    "windwp/nvim-autopairs",
    -- enable = false,
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end,
  },

  -- easily open and join statements to multiple and single lines
  {
    "AndrewRadev/splitjoin.vim",
    event = "BufReadPre",
  },

  -- add marks to sign column
  { "kshenoy/vim-signature", event = "BufReadPre" },

  -- copilot in cmp menu
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      config = function()
        vim.schedule(function()
          require("copilot").setup()
        end)
      end,
    },
  },

  -- open ai comlpetion
  {
    "jameshiew/nvim-magic",
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ac", "<Plug>nvim-magic-append-completion", "Completion", mode = "v", desc = "Completion" },
      { "<leader>aa", "<Plug>nvim-magic-suggest-alteration", "Alteration", mode = "v", desc = "Alteration" },
      { "<leader>ad", "<Plug>nvim-magic-suggest-docstring", "Docstring", mode = "v", desc = "Docstring" },
    },
    config = function()
      require("nvim-magic").setup {
        use_default_keymap = false,
      }
    end,
  },

  -- highlighting like paren and machit
  -- causes problems with lspsaga and flickering
  {
    "andymass/vim-matchup",
    lazy = false,
    -- enabled = false,
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  { "tpope/vim-surround", event = "BufReadPre" },
}

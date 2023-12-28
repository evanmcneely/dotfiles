return {
  -- helper plugins
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  "ElPiloto/significant.nvim",

  { "tpope/vim-repeat", event = "VeryLazy" },

  -- dev icons
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = { "DaikyXendo/nvim-material-icon" },
    config = function()
      require("nvim-web-devicons").setup {
        override = require("nvim-material-icon").get_icons(),
      }
    end,
  },

  -- enter :{number} to peek view of line number in buffer
  { "nacro90/numb.nvim", enabled = false, event = "BufReadPre", config = true },

  {
    "fedepujol/move.nvim",
    event = "VeryLazy",
    config = function()
      local opts = { noremap = true, silent = true }
      -- Normal-mode commands
      vim.keymap.set("n", "<C-j>", ":MoveLine(1)<CR>", opts)
      vim.keymap.set("n", "<C-k>", ":MoveLine(-1)<CR>", opts)
      vim.keymap.set("n", "<C-h>", ":MoveHChar(-1)<CR>", opts)
      vim.keymap.set("n", "<C-l>", ":MoveHChar(1)<CR>", opts)
      -- Visual-mode commands
      vim.keymap.set("v", "<C-k>", ":MoveBlock(-1)<CR>", opts)
      vim.keymap.set("v", "<C-h>", ":MoveHBlock(-1)<CR>", opts)
      vim.keymap.set("v", "<C-l>", ":MoveHBlock(1)<CR>", opts)
      vim.keymap.set("v", "<C-j>", ":MoveBlock(1)<CR>", opts)
    end,
  },

  -- adds indentation guides to all lines (including empty lines)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup {
        indent = { char = "│" },
        scope = { enabled = false },
      }
    end,
  },

  -- Ui improvements -- TODO: expand
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

  -- Comment stuff out
  {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
  },

  -- Complete parens
  {
    "windwp/nvim-autopairs",
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

  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    -- stylua: ignore
    keys = {
      { "<leader>zs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>zl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>zd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  { "tpope/vim-surround", event = "BufReadPre" },

  { "folke/twilight.nvim", enabled = false, opts = {}, cmd = { "Twilight", "TwilightEnable", "TwilightDisable" } },
  { "folke/zen-mode.nvim", enabled = false, opts = {}, cmd = { "ZenMode" } },

  {
    "abecodes/tabout.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },

  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require("illuminate").configure {}
    end,
  },

  { "smjonas/inc-rename.nvim", config = true },

  { "mbbill/undotree", cmd = "UndotreeToggle", keys = { { "<leader>eu", vim.cmd.UndotreeToggle, desc = "Undotree" } } },
}

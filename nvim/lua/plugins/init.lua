return {
  -- helper plugins
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",

  -- better repeat with .
  { "tpope/vim-repeat", event = "VeryLazy" },

  { "ElPiloto/significant.nvim" },

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
  { "yamatsum/nvim-nonicons", config = true, enabled = false },

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
    event = { "BufReadPost", "BufNewFile" },
    filetype_exclude = { "help", "alpha", "dashboard", "NvimTree", "Trouble", "lazy" },
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
      -- render = "compact",
    },
  },

  -- Comment stuff out
  { "tpope/vim-commentary", event = "BufReadPre" },

  -- complete parens
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

  -- highlighting like paren and machit
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
  {
    "cbochs/portal.nvim",
    keys = {
      { "<C-o>", "<cmd>Portal jumplist backward<cr>", desc = "Jump Backward" },
      { "<C-i>", "<cmd>Portal jumplist forward<cr>", desc = "Jump Forward" },
      { "g;", "<cmd>Portal changelist backward<cr>", desc = "Change Backward" },
      { "g,", "<cmd>Portal changelist forward<cr>", desc = "Change Forward" },
    },
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
    enabled = false,
  },
}

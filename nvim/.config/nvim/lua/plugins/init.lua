return {
  -- autoset the tabs seze
  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPost",
    config = function()
      require("guess-indent").setup {}
    end,
  },

  -- easily open and join statements to multiple and single lines
  { "AndrewRadev/splitjoin.vim", event = "BufReadPost" },

  -- add marks to sign column
  { "kshenoy/vim-signature", event = "BufReadPre" },

  -- tabout of parentheses and stuff
  {
    "abecodes/tabout.nvim",
    enabled = false,
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- enable_backwards = false,
      tabkey = "<C-l>",
      backwards_tabkey = "<C-h>",
    },
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
    keys = { { "<leader>U", vim.cmd.UndotreeToggle, desc = "Undotree" } },
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
      { "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Push" },
    },
  },

  -- really just want the merge conflict resolution tool
  {
    "tpope/vim-fugitive",
    cmd = { "Gdiff", "Git" },
    keys = {
      { "<leader>gC", "<cmd>Gdiff<cr>", desc = "Resolve conflict" },
      { "<leader>gl", "<cmd>diffget //2<cr>", desc = "Resolve left" },
      { "<leader>gr", "<cmd>diffget //3<cr>", desc = "Resolve right" },
    },
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {}
    end,
    --stylua: ignore
    keys = function()
      local harpoon = require("harpoon")
      return {
        { "<leader>a", function() harpoon:list():append() end, desc = "Add file to Harpoon" },
        { "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "File menu" },
        { "<leader>*", function() harpoon:list():select(1) end, desc = "File 1" },
        { "<leader>+", function() harpoon:list():select(2)  end, desc = "File 2" },
        { "<leader>[", function() harpoon:list():select(3)  end, desc = "File 3" },
        { "<leader>{", function() harpoon:list():select(4)  end, desc = "File 4" },
        { "<leader>(", function() harpoon:list():select(5)  end, desc = "File 5" },
      }
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
  },

  -- generate github links for the current file
  {
    "ruifm/gitlinker.nvim",
    lazy = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup()
    end,
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").copy_to_clipboard })
        end,
        desc = "Link to Github",
      },
      {
        "<leader>gY",
        function()
          require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser })
        end,
        desc = "Open in Github",
      },
    },
  },

  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    -- enabled = false,
    -- stylua: ignore
    config = function ()
      vim.g.codeium_disable_bindings = 1
      vim.keymap.set("i", "<S-Tab>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      -- vim.keymap.set("i", "<C-a>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
      vim.keymap.set("i", "<C-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<C-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    end,
  },
}

return {
  -- easily open and join statements to multiple and single lines
  { "AndrewRadev/splitjoin.vim", event = "BufReadPost" },

  -- add marks to sign column
  { "kshenoy/vim-signature", event = "BufReadPre" },

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
    enabled = false,
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

  -- integration with tmux
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- easy file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {
        settings = {
          -- save menu on close
          sync_on_ui_close = true,
          save_on_toggle = true,
        },
      }
    end,
    --stylua: ignore
    keys = function()
      local harpoon = require("harpoon")
      return {
        { "<leader>ha", function() harpoon:list():append() end, desc = "Add file to Harpoon" },
        { "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "File menu" },
        { "<leader>+", function() harpoon:list():select(1) end, desc = "File 1" },
        { "<leader>1", function() harpoon:list():select(1) end, desc = "File 1" },
        { "<leader>[", function() harpoon:list():select(2)  end, desc = "File 2" },
        { "<leader>2", function() harpoon:list():select(2)  end, desc = "File 2" },
        { "<leader>{", function() harpoon:list():select(3)  end, desc = "File 3" },
        { "<leader>3", function() harpoon:list():select(3)  end, desc = "File 3" },
        { "<leader>(", function() harpoon:list():select(4)  end, desc = "File 4" },
        { "<leader>4", function() harpoon:list():select(4)  end, desc = "File 4" },
        { "<leader>&", function() harpoon:list():select(5)  end, desc = "File 5" },
        { "<leader>5", function() harpoon:list():select(5)  end, desc = "File 5" },
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
    --stylua: ignore
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
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
    --stylua: ignore
    keys = {
      { "<leader>gy", function() require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").copy_to_clipboard }) end, desc = "Link to Github" },
      { "<leader>gY", function() require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser }) end, desc = "Open in Github" },
    },
  },

  {
    "evanmcneely/enlighten.nvim",
    dir = "~/dev/personal/enlighten.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    config = function()
      require('enlighten'):setup()
      vim.keymap.set("v", "<leader>aa", function() require("enlighten"):toggle_prompt() end, { desc = "Prompt" })
      vim.keymap.set("n", "<leader>aa", function() require("enlighten"):toggle_prompt() end, { desc = "Prompt" })
      vim.keymap.set("v", "<leader>ac", function() require("enlighten"):toggle_chat() end, { desc = "Chat" })
      vim.keymap.set("n", "<leader>ac", function() require("enlighten"):toggle_chat() end, { desc = "Chat" })
      vim.keymap.set("n", "<leader>af", function() require("enlighten"):focus() end, { desc = "Focus prompt or chat" })
      vim.keymap.set("n", "<leader>al", function() require("enlighten").logger:show() end, { desc = "Enlighten logs" })
    end,
  },

  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        "plenary.nvim",
      },
    },
  },
}

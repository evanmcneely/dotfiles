return {
  -- WezTerm integration
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      require("smart-splits").setup {}

      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
    end,
  },

  -- easily open and join statements to multiple and single lines
  { "AndrewRadev/splitjoin.vim", event = "BufReadPost" },

  -- add marks to sign column
  { "kshenoy/vim-signature", event = "BufReadPre" },

  { "matze/vim-move", event = "BufReadPost" },

  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 5,
        },
      }

      -- Open parent directory in popup
      vim.keymap.set("n", "<leader>e", require("oil").toggle_float, { desc = "Open parent directory" })
    end,
  },

  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    enabled = true,
    event = "VeryLazy",
    vscode = true,
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = require "gitsigns"

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>gha", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ga", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>gr", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle line blame")
      end,
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    enabled = true, -- see if I really need/want this
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },

  -- navigate undo/redo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>cu", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
      { "<leader>cf", vim.cmd.UndotreeFocus, desc = "Focus Undotree" },
    },
  },

  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>dm", "<cmd>DiffviewOpen master<cr>", desc = "Diffview master" },
    },
  },

  -- easy file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
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
        { "<leader>H", function() harpoon:list():append() end, desc = "Add file to Harpoon" },
        { "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "File menu" },
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
    "folke/todo-comments.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      -- TODO = {
      --   alt = { "TODO", "todo" },
      -- },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s* ]],
      },
    },
  },

  {
    "oysandvik94/curl.nvim",
    version = false,
    cmd = { "CurlOpen", "CurlCollection" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
}

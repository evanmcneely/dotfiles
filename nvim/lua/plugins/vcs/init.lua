return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
      -- kind = "tab",
      -- commit_popup = {
      --   kind = "floating",
      -- },
      -- popup = {
      --   kind = "floating",
      -- },
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
      {
        "<leader>gc",
        function()
          require("neogit").open { "commit" }
        end,
        desc = "Commit",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = true,
      signs = {
        add = {
          hl = "GitSignsAdd",
          text = "▍",
          numhl = "GitSignsAddNr",
          linehl = "GitSignsAddLn",
        },
        change = {
          hl = "GitSignsChange",
          text = "▍",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "▸",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "▾",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "▍",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      -- update_debounce = 100,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Pevious hunk" })

        -- Actions
        map({ "n", "v" }, "<leader>gha", gs.stage_hunk, { desc = "Stage Hunk" })
        map({ "n", "v" }, "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>ga", gs.stage_buffer, { desc = "Stage Buffer" })
        map("n", "<leader>gr", gs.reset_buffer, { desc = "Reset Buffer" })
        map("n", "<leader>gb", function()
          gs.blame_line { full = true }
        end, { desc = "Blame Line" })
        map("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Diff This" })
        map("n", "<leader>gD", function()
          gs.diffthis "~"
        end, { desc = "Diff This ~" })
        -- map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle Delete" })

        -- Text object
        -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
      end,
    },
  },
  {
    "mattn/vim-gist",
    dependencies = { "mattn/webapi-vim" },
    cmd = { "Gist" },
    config = function()
      vim.g.gist_open_browser_after_post = 1
    end,
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      -- change_directory_command = <str> -- default: "cd",
      -- update_on_change = <boolean> -- default: true,
      -- update_on_change_command = <str> -- default: "e .",
      -- clearjumps_on_change = <boolean> -- default: true,
      -- autopush = <boolean> -- default: false,
    end,
    keys = {
      {
        "<leader>gW",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Worktrees",
      },
      {
        "<leader>gw",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Create worktree",
      },
    },
  },
}

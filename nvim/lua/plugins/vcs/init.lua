return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    -- TODO: key maps
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      { "<leader>gs", "<cmd>Neogit kind=tab<cr>", desc = "Status" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = true,
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
        -- TODO: move these to keymaps
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
        map("n", "<leader>gt", gs.toggle_deleted, { desc = "Toggle Delete" })
      end,
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
    end,
    keys = {
      {
        "<leader>gw",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Worktree",
      },
      {
        "<leader>gW",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "create worktree",
      },
    },
  },
}

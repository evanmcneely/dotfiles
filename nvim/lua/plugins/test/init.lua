return {
  {
    "nvim-neotest/neotest",
    enabled = false,
    keys = {
      -- { "<leader>tF", "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
      -- { "<leader>tL", "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
      -- { "<leader>ta", "<cmd>w|lua require('neotest').run.attach()<cr>", desc = "Attach" },
      { "<leader>tf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
      { "<leader>tl", "<cmd>w|lua require('neotest').run.run_last()<cr>", desc = "Last" },
      { "<leader>tn", "<cmd>w|lua require('neotest').run.run()<cr>", desc = "Nearest" },
      -- { "<leader>tN", "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
      { "<leader>to", "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
      { "<leader>ts", "<cmd>w|lua require('neotest').run.stop()<cr>", desc = "Stop" },
      { "<leader>tS", "<cmd>w|lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "stevearc/overseer.nvim",
      -- JavaScript
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function()
      return {
        adapters = {
          require "neotest-jest",
          require "neotest-vitest",
          require("neotest-playwright").adapter {
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          },
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            if require("utils").has "trouble.nvim" then
              vim.cmd "Trouble quickfix"
            else
              vim.cmd "copen"
            end
          end,
        },
        -- overseer.nvim
        consumers = {
          overseer = require "neotest.consumers.overseer",
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      -- { "<leader>uoR", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
      -- { "<leader>uoa", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      -- { "<leader>uob", "<cmd>OverseerBuild<cr>", desc = "Build" },
      { "<leader>uoc", "<cmd>OverseerClose<cr>", desc = "Close" },
      -- { "<leader>uod", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      -- { "<leader>uol", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
      { "<leader>uoo", "<cmd>OverseerOpen<cr>", desc = "Open" },
      -- { "<leader>uoq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
      { "<leader>uor", "<cmd>OverseerRun<cr>", desc = "Run" },
      -- { "<leader>uos", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
      { "<leader>uot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
    },
    config = true,
  },
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage" },
    config = function()
      require("coverage").setup()
    end,
  },
}

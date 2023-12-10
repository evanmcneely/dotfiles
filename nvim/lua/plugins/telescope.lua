return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "stevearc/aerial.nvim",
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files theme=dropdown previewer=false<cr>", desc = "Find Files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      {
        "<leader>sb",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Buffer",
      },
      {
        "<leader>zc",
        function()
          require("telescope.builtin").colorscheme { enable_preview = true }
        end,
        desc = "Colorscheme",
      },
      { "<leader>vo", "<cmd>Telescope aerial<cr>", desc = "Code Outline" },
    },
    config = function(_, _)
      local telescope = require "telescope"
      local icons = require "config.icons"
      local actions = require "telescope.actions"
      local actions_layout = require "telescope.actions.layout"
      local mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["?"] = actions_layout.toggle_preview,
        },
      }

      local opts = {
        defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          mappings = mappings,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
          },
        },
      }
      telescope.setup(opts)
      telescope.load_extension "fzf"
      telescope.load_extension "aerial"
    end,
  },
  {
    "stevearc/aerial.nvim",
    config = true,
  },
  {
    "ahmedkhalf/project.nvim",
    enabled = false,
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git" },
        ignore_lsp = { "null-ls" },
      }
    end,
  },
}

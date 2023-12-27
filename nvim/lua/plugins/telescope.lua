return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope git_files theme=dropdown previewer=false<cr>", desc = "Find Files" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
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
          ["<esc>"] = actions.close,
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
    end,
  },
}

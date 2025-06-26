return {
  "nvim-telescope/telescope.nvim",
  lazy=false,
  -- cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  -- stylua: ignore
  keys = {
    { "<leader><leader>", "<cmd>Telescope find_files theme=dropdown previewer=false<cr>", desc = "Find Files" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>s.", function() require("telescope.builtin").find_files { cwd = vim.fn.expand "%:p:h" } end, desc = "Find Files (current)" },
    { "<leader>sb", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Buffer" },
  },
  opts = function()
    local actions = require "telescope.actions"

    local telescopeConfig = require "telescope.config"
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) } -- Clone the default Telescope configuration
    table.insert(vimgrep_arguments, "--hidden") -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--glob") -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "!**/.git/*")

    require('telescope').load_extension('git_worktree')

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        mappings = {
          i = {
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      vimgrep_arguments = vimgrep_arguments,
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
    }
  end,
}

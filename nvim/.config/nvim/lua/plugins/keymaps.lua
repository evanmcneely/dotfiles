return {
  -- replate which key keymaps
  {
    "folke/which-key.nvim",
    opts = {
      show_help = false,
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        -- ["<leader>e"] = { name = "+explore" },
        ["<leader>g"] = { name = "+git", h = { name = "+hunk" } },
        -- ["<leader>h"] = { name = "+harpoon" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
        ["<leader>z"] = {
          name = "+system",
          l = { "<cmd>Lazy<cr>", "Lazy" },
          m = { "<cmd>Mason<cr>", "Mason" },
          L = { "<cmd>LspInfo<cr>", "Lsp info" },
          N = { "<cmd>NullLsInfo<cr>", "Null ls info" },
          C = { "<cmd>ConformInfo<cr>", "Conform info" },
          n = { name = "+noice" },
        },
      },
    },
  },

  -- replace all NeoTree keymaps with my own
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function()
      return {
        { "<C-e>", "<cmd>Neotree toggle %:p:h<cr>", desc = "File Explorer" },
      }
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    -- better navigation in insert mode
    opts = function(_, opts)
      local actions = require "telescope.actions"
      opts.defaults.mappings = opts.defaults.mappings or {}
      opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings, {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<esc>"] = actions.close,
        },
      })
    end,
    -- replace all Telescope keymaps with my own
    keys = function()
      return {
        { "<leader><leader>", "<cmd>Telescope find_files theme=dropdown previewer=false<cr>", desc = "Find Files" },
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        -- { "<leader>sb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>sv", "<cmd>Telescope git_files theme=dropdown previewer=false<cr>", desc = "Git Files" },
        { "<leader>sr", "<cmd>Telescope oldfiles theme=dropdown previewer=false<cr>", desc = "Recent" },
        {
          "<leader>sb",
          function()
            require("telescope.builtin").current_buffer_fuzzy_find()
          end,
          desc = "Buffer",
        },
      }
    end,
  },

  -- same keymaps but under <leader>z
  {
    "folke/noice.nvim",
    keys = function()
      -- stylua: ignore
      return {
        { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
        { "<leader>znl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
        { "<leader>znh", function() require("noice").cmd("history") end, desc = "Noice History" },
        { "<leader>zna", function() require("noice").cmd("all") end, desc = "Noice All" },
        { "<leader>znd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
        { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
        { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
      }
    end,
  },

  -- don't need these
  {
    "williamboman/mason.nvim",
    keys = function()
      return {}
    end,
  },

  -- add the ability to toggle line blame
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle line blame" },
    },
  },
}

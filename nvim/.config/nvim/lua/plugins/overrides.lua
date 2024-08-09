local i = require "utils.icons"

return {
  -- replace which key keymaps
  {
    "folke/which-key.nvim",
    opts = {
      show_help = false,
      spec = {
        mode = { "n", "v" },
        { "<leader>&", hidden = true },
        { "<leader>(", hidden = true },
        { "<leader>+", hidden = true },
        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader><tab>", group = "tabs" },
        { "<leader>[", hidden = true },
        { "<leader>a", group = "AI", icon = i.misc.Robot },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git", icon = i.git.Diff },
        { "<leader>gh", group = "hunk" },
        { "<leader>h", group = "harpoon", icon = i.ui.Files },
        { "<leader>l", group = "lsp" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader>z", group = "system", icon = i.ui.Gear },
        { "<leader>zc", "<cmd>ConformInfo<cr>", desc = "Conform info" },
        { "<leader>zi", "<cmd>LspInfo<cr>", desc = "Lsp info" },
        { "<leader>zl", "<cmd>Lazy<cr>", desc = "Lazy" },
        { "<leader>zm", "<cmd>Mason<cr>", desc = "Mason" },
        { "<leader>zn", group = "noice" },
        { "<leader>{", hidden = true },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        -- enabled window picking for Neo-tree
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "3.*",
        config = function()
          require("window-picker").setup {
            hint = "floating-big-letter",
            show_prompt = true,
          }
        end,
      },
    },
    opts = {
      enable_diagnostics = false, -- don't need it
      window = {
        width = 50,
        -- position = "current",
      },
      default_component_configs = {
        modified = { symbol = "" }, -- default is [+]
        file_size = { enabled = false }, -- hide
        type = { enabled = false }, -- hide
        created = { enabled = false }, -- hide
        last_modified = {
          -- enabled = false,
          required_width = 60, -- show on default width
        },
      },
      filesystem = { filtered_items = { visible = true } }, -- show visible files
    },
    -- replace all NeoTree keymaps with my own
    keys = function()
      return {
        { "<C-e>", "<cmd>Neotree toggle<cr>", desc = "File Explorer" },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"

      -- add tab completion and C-j + C-k navigation
      opts.mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<C-Y>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
      }

      opts.experimental = {} -- disable ghost text, let codeiem show ghost text
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        graphql = { "prettier" },
        handlebars = { "prettier" },
        python = { "isort", "black" },
        php = { "phpcbf" },
        lua = { "stylua" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.events = { "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" } -- extends list to include TextChanged event
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft, {
        ["*"] = { "typos" }, -- add spell checks
        lua = { "luacheck" },
      })

      -- wrap so typos show up as hints not warnings
      local lint = require "lint"
      lint.linters.typos = require("lint.util").wrap(lint.linters.typos, function(diagnostic)
        diagnostic.severity = vim.diagnostic.severity.HINT
        return diagnostic
      end)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- TODO: use neoconf for local setup
      servers = {
        pyright = {
          reportGeneralTypeIssues = false, -- we don't use types at Leadpages
          reportUnboundVariable = false, -- not working
        },
      },
      inlay_hints = {
        enabled = false, -- off by default
      },
    },
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

      -- `hidden = true` is not supported in text grep commands so we need to add it here
      local telescopeConfig = require "telescope.config"
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) } -- Clone the default Telescope configuration
      table.insert(vimgrep_arguments, "--hidden") -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--glob") -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "!**/.git/*")
      opts.defaults.vimgrep_arguments = vimgrep_arguments
      opts.pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      }
    end,
    -- replace all Telescope keymaps with my own
    -- stylua: ignore
    keys = function()
      return {
        { "<leader><leader>", "<cmd>Telescope find_files theme=dropdown previewer=false<cr>", desc = "Find Files" },
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
        { "<leader>sb", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Buffer" },
      }
    end,
  },

  {
    "williamboman/mason.nvim",
    -- don't need these
    keys = function()
      return {}
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    -- add the ability to toggle line blame
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle line blame" },
    },
  },

  {
    "folke/noice.nvim",
    -- same keymaps but under <leader>z
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

  {
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
    opts = {
      scope = { enabled = false },
    },
  },
}

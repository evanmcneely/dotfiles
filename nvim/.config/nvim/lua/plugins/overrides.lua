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
        ["<leader>g"] = { name = "+git", h = { name = "+hunk" } },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>r"] = { name = "+refactor" },
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
        -- hide these from menu
        ["<leader>1"] = "which_key_ignore",
        ["<leader>2"] = "which_key_ignore",
        ["<leader>3"] = "which_key_ignore",
        ["<leader>4"] = "which_key_ignore",
        ["<leader>5"] = "which_key_ignore",
        ["<leader>+"] = "which_key_ignore",
        ["<leader>{"] = "which_key_ignore",
        ["<leader>["] = "which_key_ignore",
        ["<leader>("] = "which_key_ignore",
        ["<leader>&"] = "which_key_ignore",
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
    -- enabled window picking for Neo-tree
    dependencies = {
      {
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
    "L3MON4D3/LuaSnip",
    -- disable default tab and S-tab
    keys = function()
      return {}
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local luasnip = require "luasnip"
      local cmp = require "cmp"

      -- add tab completion and C-j + C-k navigation
      opts.mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s", "c" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s", "c" }),
        ["<cr>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true }
          else
            fallback()
          end
        end, { "i", "s" }),
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
        -- ["*"] = { "codespell" },
      },
    },
    keys = {
      -- stylua: ignore
      { "<leader>f", function() require("conform").format { lsp_fallback = true } end, mode = { "n", "v" }, desc = "Format", },
    },
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
    },
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require "null-ls"
      opts.sources = opts.sources or {}
      -- add codespell
      -- table.insert(opts.sources, nls.builtins.diagnostics.codespell)
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
    keys = function()
      return {
        {
          "<leader><leader>",
          "<cmd>Telescope find_files theme=dropdown previewer=false<cr>",
          desc = "Find Files",
        },
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
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
}

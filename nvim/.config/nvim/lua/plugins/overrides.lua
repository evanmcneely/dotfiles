return {
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
        width = 40,
        -- position = "current",
      }, -- default width
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
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm()
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
        ["*"] = { "codespell" },
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
          -- reportUnboundVariable = false, -- not working
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
      table.insert(opts.sources, nls.builtins.diagnostics.codespell)
    end,
  },

  {
    "folke/noice.nvim",
  },
}

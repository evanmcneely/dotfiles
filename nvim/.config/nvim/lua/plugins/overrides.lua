local icons = require "utils.icons"
local Job = require "plenary.job"

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- enabled window picking for Neo-tree
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
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
      window = { width = 60 }, -- default width
      default_component_configs = {
        modified = { symbol = "~" }, -- default is [+]
        file_size = { enabled = false }, -- hide
        type = { enabled = false }, -- hide
        created = { enabled = false }, -- hide
        last_modified = {
          enabled = true,
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
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s", "c" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s", "c" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
          else
            fallback()
          end
        end, { "i", "s" }),
      }

      -- addd border to docs
      opts.window = {
        documentation = cmp.config.window.bordered(),
      }
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- async get the git repo the current file is in
      local function get_repo()
        local results = {}
        local job = Job:new {
          command = "git",
          args = { "rev-parse", "--show-toplevel" },
          cwd = vim.fn.expand "%:p:h",
          on_stdout = function(_, line)
            table.insert(results, line)
          end,
        }
        job:sync()
        if results[1] ~= nil then
          return vim.fn.fnamemodify(results[1], ":t")
        else
          return "no git"
        end
      end

      -- override "mode" with git repo
      opts.sections.lualine_a = { {
        get_repo,
        icon = icons.git.Repo,
      } }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- TODO: use neoconf for local setup
          reportGeneralTypeIssues = false, -- we don't use types at Leadpages
          -- reportUnboundVariable = false, -- not working
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- use prettierd if possible
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        python = { "isort", "black" },
        -- ["php = { "phpcbf" }, -- not tested
        ["*"] = { "codespell" },
      },
    },
  },
}
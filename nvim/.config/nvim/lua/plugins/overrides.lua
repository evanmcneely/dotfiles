local icons = require "utils.icons"
local colors = require "utils.colors"
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
      local Util = require "lazyvim.util"
      local lualine_require = require "lualine_require"
      lualine_require.require = require

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

      -- override lualine sections with custom statusline
      opts.sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            get_repo,
            icon = icons.git.Repo,
          },
          {
            "branch",
            separator = "",
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            diff_color = {
              added = { fg = colors.tokyonight.gitSigns.add },
              modified = { fg = colors.tokyonight.gitSigns.change },
              removed = { fg = colors.tokyonight.gitSigns.delete },
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            draw_empty = true,
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { Util.lualine.pretty_path(), separator = "" },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = Util.ui.fg("Statement"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = Util.ui.fg("Debug"),
          },
          {
            function()
              local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
              return icons.ui.Tab .. " " .. shiftwidth
            end,
            padding = 1,
          },
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
          { "mode" },
        },
        lualine_y = {},
        lualine_z = {},
      }
    end,
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

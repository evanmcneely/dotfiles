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
  },

  -- disable default tab and S-tab
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      local luasnip = require "luasnip"
      local cmp = require "cmp"

      -- add tab completion and C-j + C-k navigation
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
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
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
          else
            fallback()
          end
        end, { "i", "s" }),
      })
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
    "folke/todo-comments.nvim",
    opts = function(_, opts)
      -- do not use the sign column
      opts.signs = false
    end,
  },
}

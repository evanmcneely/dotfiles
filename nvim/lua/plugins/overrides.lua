local icons = require "utils.icons"
local Job = require "plenary.job"

return {
  -- enabled window picking for Neo-tree
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

  -- add j/k completion navigation
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.mapping = cmp.config.mapping(vim.list_extend(opts.mapping, {
        -- TODO: not working
        -- ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        -- ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        -- ["<Tab>"] = cmp.mapping.complete,
      }))
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
}

local function tab()
  local suggestion = package.loaded["supermaven-nvim.completion_preview"]
  if suggestion and suggestion.has_suggestion() then
    return "<cmd>lua require('supermaven-nvim.completion_preview').on_accept_suggestion()<cr>"
  end
  return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
end

return {

  -- snippets
  {
    "nvim-cmp",
    dependencies = {
      {
        "garymjr/nvim-snippets",
        opts = {
          friendly_snippets = true,
        },
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(item)
          vim.snippet.expand(item.body)
        end,
      }
    end,
    -- stylua: ignore
    keys = {
      { "<Tab>", tab, expr = true, silent = true, mode = { "i", "s" }, desc = "Accept suggestion or jump snippet" },
      { "<S-Tab>", function() return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>" end, expr = true, silent = true, mode = { "i", "s" } },
    },
  },

  -- comments
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Manage libuv types with lazy. Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },

  -- best auto pairirng of parentheses I've found
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {
        disable_filetype = { "TelescopePrompt", "vim" },
      }
    end,
  },

  {
    "evanmcneely/enlighten.nvim",
    enabled = false,
    dir = "~/dev/personal/enlighten.nvim",
    event = "VeryLazy",
    opts = {
      ai = {
        model = "claude-sonnet-4-6",
        provider = "anthropic",
        temperature = 0.2,
      },
      settings = {
        chat = {
          width = 110,
        },
        edit = {
          showHelp = false,
          showTitle = false,
          border = "",
          height = 3,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "\\e", function() require("enlighten").edit() end, desc = "Enlighten Edit", mode = { "n", "v" } },
      { "\\g", function() require("enlighten").edit({ diff_mode = "off", auto_close = true }) end, desc = "Enlighten Edit (auto-accept)", mode = { "n", "v" } },
      { "\\c", function() require("enlighten").chat() end, desc = "Enlighten Chat", mode = { "n", "v" } },
      { "\\y", function() require("enlighten").keep() end, mode = { "n", "v" } },
      { "\\Y", function() require("enlighten").keep_all() end,mode = { "n" } },
      { "\\n", function() require("enlighten").discard() end, mode = { "n", "v" } },
      { "\\N", function() require("enlighten").discard_all() end,mode = { "n" } },
      { "\\l", function() require("enlighten").logger:show() end, desc = "Enlighten Logs" },
      { "\\p", function() require("enlighten").picker:open() end },
    },
  },

  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    --  Call config for python files and load the cached venv automatically
    ft = "python",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
  },

  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenStart",
      "SupermavenStop",
      "SupermavenRestart",
      "SupermavenToggle",
      "SupermavenStatus",
      "SupermavenUseFree",
      "SupermavenUsePro",
      "SupermavenLogout",
      "SupermavenShowLog",
      "SupermavenClearLog",
    },
    config = function()
      require("supermaven-nvim").setup {}
      -- Keep the same Tab handler regardless of which completion plugin loads first.
      vim.keymap.set({ "i", "s" }, "<Tab>", tab, { expr = true, silent = true, desc = "Accept suggestion or jump snippet" })
      -- Upstream logs status at trace level, hiding it with the default config.
      vim.api.nvim_create_user_command("SupermavenStatus", function()
        local running = require("supermaven-nvim.api").is_running()
        vim.notify("Supermaven is " .. (running and "running" or "not running"), vim.log.levels.INFO)
      end, {})
    end,
  },

  {},
}

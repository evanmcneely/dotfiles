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
    keys = {
      {
        "<Tab>",
        function()
          return vim.snippet.active { direction = 1 } and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
      {
        "<S-Tab>",
        function()
          return vim.snippet.active { direction = -1 } and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
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
    dir = "~/dev/personal/enlighten.nvim",
    event = "VeryLazy",
    opts = {
      ai = {
        chat = {
          provider = "anthropic",
          model = "claude-3-5-sonnet-20240620",
        },
      },
      settings = {
        chat = {
          width = 100,
        },
        edit = {
          showHelp = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>aE", function() require("enlighten").edit() end, desc = "Enlighten Edit", mode = { "n", "v" } },
      { "<leader>aC", function() require("enlighten").chat() end, desc = "Enlighten Chat", mode = { "n", "v" } },
      { "<leader>aL", function() require("enlighten.logger"):show() end, desc = "Enlighten Logs" },
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
    branch = "regexp", -- Use this branch for the new version
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      hints = { enabled = false },
      diff = {
        autojump = false,
      },
      file_selector = {
        provider = "telescope",
        provider_opts = {},
      },
    },
    build = "make",
    dependencies = {
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "Avante" },
        },
        ft = { "Avante" },
      },
    },
    keys = {
      {
        "<leader>ap",
        function()
          return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image() or require("img-clip").paste_image()
        end,
        desc = "clip: paste image",
      },
    },
  },
}

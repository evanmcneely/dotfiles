return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      { "j-hui/fidget.nvim", enabled = false, opts = {} }, -- TODO: move to experimental
      { "folke/neodev.nvim", opts = {} },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
      "RRethy/vim-illuminate", -- TODO: not working
    },
    opts = {
      servers = {
        dockerls = {},
        html = {},
        cssls = {},
        vimls = {},
        yamlls = {},
        bashls = {},
        -- stylelint_lsp = {},
        -- docker_compose_language_service = {},
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.attach").setup(plugin, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "ruff",
        "eslint_d",
        "black",
        "debugpy",
        "codelldb",
        "prettier",
        "codespell",
        "cspell",
        "beautysh",
        "markdownlint",
        "yamllint",
        "phpcs",
        "phpcbf",
      },
    },
    config = function(_, opts)
      require("mason").setup()
      local mr = require "mason-registry"
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require "null-ls"
      nls.setup {
        sources = {
          -- php
          nls.builtins.formatting.phpcbf.with {
            command = "./vendor/bin/phpcbf",
            extra_args = { "--standard=phpcs.xml" },
          },
          nls.builtins.diagnostics.phpcs.with {
            command = "./vendor/bin/phpcs",
            extra_args = { "--standard=phpcs.xml" },
          },

          -- python
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,
          nls.builtins.diagnostics.ruff,

          -- lua
          nls.builtins.formatting.stylua,

          -- js
          nls.builtins.formatting.prettier.with {
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
          },
          nls.builtins.code_actions.eslint,

          -- other
          nls.builtins.formatting.beautysh,
          nls.builtins.formatting.markdownlint,
          nls.builtins.diagnostics.codespell,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.yamllint,
        },
      }
    end,
  },
  { "jay-babu/mason-null-ls.nvim", opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false } },
  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("nvim-navic").setup {}
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },
}

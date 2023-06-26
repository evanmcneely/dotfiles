return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      {
        "folke/neodev.nvim",
        opts = { library = { plugins = { "neotest", "nvim-dap-ui" }, types = true } },
      },
      { "j-hui/fidget.nvim", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      "simrat39/rust-tools.nvim",
      "rust-lang/rust.vim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "RRethy/vim-illuminate",
      "jay-babu/mason-null-ls.nvim",
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
        -- "eslint_d",
        -- "autopep8",
        "black",
        "debugpy",
        "codelldb",
        "prettier",
        "codespell",
        "cspell",
        "beautysh",
        "markdownlint",
        -- "vulture",
        "yamllint",
        -- "stylelint_lsp",
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
          -- python
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,
          nls.builtins.diagnostics.ruff,
          -- nls.builtins.formatting.autopep8,
          -- nls.builtins.diagnostics.vulture,

          -- lua
          nls.builtins.formatting.stylua,
          -- nls.builtins.diagnostics.stylelint_lsp,

          -- js
          nls.builtins.formatting.prettier,
          nls.builtins.code_actions.eslint,
          -- nls.builtins.code_actions.eslint_d,
          -- require "typescript.extensions.null-ls.code-actions",

          -- other
          nls.builtins.formatting.beautysh,
          nls.builtins.formatting.markdownlint,
          nls.builtins.diagnostics.codespell,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.yamllint,
          -- nls.builtins.code_actions.cspell,
          -- nls.builtins.code_actions.gitsigns,
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

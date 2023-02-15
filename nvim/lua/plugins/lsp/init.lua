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
    },
    opts = {
      servers = {
        dockerls = {},
        html = {},
        cssls = {},
        vimls = {},
        yamlls = {},
        bashls = {},
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
        -- "cspell",
        "beautysh",
        "markdownlint",
        "vulture",
        "yamllint",
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
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.beautysh,
          nls.builtins.formatting.markdownlint,
          -- nls.builtins.formatting.autopep8,
          nls.builtins.diagnostics.ruff.with { extra_args = { "--max-line-length=180" } },
          nls.builtins.diagnostics.codespell,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.vulture,
          nls.builtins.diagnostics.yamllint,
          -- nls.builtins.code_actions.eslint_d,
          -- nls.builtins.code_actions.cspell,
          nls.builtins.code_actions.eslint,
          -- nls.builtins.code_actions.gitsigns,
          require "typescript.extensions.null-ls.code-actions",
        },
      }
    end,
  },
  {
    "SmiteshP/nvim-navic",
    -- enabled = false,
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

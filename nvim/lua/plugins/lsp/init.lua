return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    opts = {
      servers = {
        vimls = {},
        bashls = {},
      },
    },
    config = function(plugin, opts)
      require("plugins.lsp.attach").setup(plugin, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = { "codespell", "beautysh" },
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
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = { nls.builtins.diagnostics.codespell, nls.builtins.formatting.beautysh },
      }
    end,
  },
  { "jay-babu/mason-null-ls.nvim", opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false } },
  {
    "nvimdev/lspsaga.nvim",
    event = "BufReadPost",
    config = function()
      require("lspsaga").setup {
        lightbulb = { enable = false },
        symbol_in_winbar = {
          enable = false,
          hide_keyword = true,
          folder_level = 3,
          show_file = true,
        },
      }
    end,
  },
  { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
}

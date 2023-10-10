return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "php" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "autozimu/LanguageClient-neovim" },
    opts = {
      servers = {
        intelephense = {
          LanguageClient_serverCommands = {
            rust = { "~/.cargo/bin/rustup", "run", "stable", "rls" },
            javascript = { "/usr/local/bin/javascript-typescript-stdio" },
            -- 'javascript.jsx' = {'tcp://127.0.0.1:2089'},
            python = { "/usr/local/bin/pyls" },
            ruby = { "~/.rbenv/shims/solargraph", "stdio" },
          },
        },
      },
      setup = {
        intelephense = function(_, _)
          -- local lsp_utils = require "plugins.lsp.utils"
          -- lsp_utils.on_attach(function(client, buffer)
          -- if client.name == "intelliphence" then
          --   client.server_capabilities.document_formatting = true
          -- end
          -- end)
        end,
      },
    },
  },
}

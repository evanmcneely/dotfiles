return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        -- TODO: use neoconf for local setup
        reportGeneralTypeIssues = false, -- we don't use types at Leadpages
        -- reportUnboundVariable = false, -- not working
      },
    },
  },
}

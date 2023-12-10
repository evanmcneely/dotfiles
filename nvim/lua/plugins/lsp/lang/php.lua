return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          files = {
            maxSize = 5000000,
          },
          stubs = {
            "wordpress",
            "wordpress-tests",
          },
        },
      },
      setup = {},
    },
  },
}

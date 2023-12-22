return {
  {
    "renerocksai/telekasten.nvim",
    enabled = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      home = vim.env.HOME .. "/zettelkasten",
    },
    ft = { "markdown" },
  },
  {
    "epwalsh/obsidian.nvim",
    enabled = false,
    opts = {
      dir = vim.env.HOME .. "/obsidian",
      completion = {
        nvim_cmp = true,
      },
    },
    ft = { "markdown" },
  },
}

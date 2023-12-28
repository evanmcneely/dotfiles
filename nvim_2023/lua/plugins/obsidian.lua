return {
  "epwalsh/obsidian.nvim",
  enabled = false,
  opts = {
    dir = vim.env.HOME .. "/obsidian",
    completion = {
      nvim_cmp = true,
    },
  },
  ft = { "markdown" },
}

--- Install lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup {
  spec = {
    -- all the default stuff
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- languages - use these provided configs
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    -- some nice things
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.editor.leap" },
    -- overrides and extensions
    { import = "plugins" },
    { import = "plugins.languages" },
  },
  defaults = { lazy = true, version = "*" },
  install = { missing = true, colorscheme = { "tokyonight" } },
  checker = { enabled = false },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

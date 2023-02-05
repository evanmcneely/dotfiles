--- Install lazy.nvim
-- local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system {
--     "git",
--     "clone",
--     "--filter=blob:none",
--     "https://github.com/folke/lazy.nvim.git",
--     "--branch=stable",
--     lazypath,
--   }
-- end
-- vim.opt.rtp:prepend(lazypath)

require "config.options"
require "config.lazy"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "config.autocmds"
    require "config.keymaps"
  end,
})


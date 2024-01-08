require "config.lazy"

-- firenvim config
vim.g.firenvim_config = {
  globalSettings = { alt = "all" },
  localSettings = {
    [".*"] = {
      takeover = "never",
    },
  },
}

if vim.g.started_by_firenvim == true then
  -- don't show the status line or sign column
  vim.o.laststatus = 0
  vim.o.signcolumn = "no"
end

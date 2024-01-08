-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.wo.relativenumber = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
      vim.wo.relativenumber = false
    end
  end,
})

-- vim.api.nvim_create_autocmd({ "UIEnter" }, {
--   callback = function()
--     local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
--     if client ~= nil and client.name == "Firenvim" then
--       print "firenvim"
--       vim.o.laststatus = 0
--     end
--   end,
-- })

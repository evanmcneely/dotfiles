local indent = 2

--vim.o.formatoptions = "jcroqlnt"
--vim.o.shortmess = "filnxtToOFWIcC"
vim.opt.breakindent = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.conceallevel = 3
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.joinspaces = false
vim.opt.laststatus = 0
vim.opt.title = true
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
-- vim.opt.relativenumber = true
vim.opt.scrolloff = 8
-- vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true
vim.opt.shiftwidth = indent
vim.opt.showmode = false
-- vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = indent
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.wildmode = "longest:full,full"
vim.opt.scrollback = 100000
vim.opt.cmdheight = 1
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.showbreak = "+++"

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.clipboard = "unnamedplus"

if vim.fn.has "nvim-0.9.0" == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append { C = true }
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

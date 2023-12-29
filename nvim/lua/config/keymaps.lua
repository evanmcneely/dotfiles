-- delete defaults https://www.lazyvim.org/configuration/general#keymaps
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Better escape using jk in insert and terminal mode
vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("t", "jj", "<C-\\><C-n>")

-- insert blank lines above and below
vim.keymap.set("n", "[<space>", "O<esc>^", { desc = "Pad above" })
vim.keymap.set("n", "]<space>", "o<esc>^", { desc = "Pad below" })

-- Paste over currently selected text without yanking it
vim.keymap.set("v", "p", '"_dP')

-- useful
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "Q", "@")

-- better viewing
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Move in insert mode with using the arrow keys
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")

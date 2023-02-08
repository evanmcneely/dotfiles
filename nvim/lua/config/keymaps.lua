local keymap = vim.keymap.set

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "g,", "g,zvzz")
keymap("n", "g;", "g;zvzz")

-- Better escape using jk in insert and terminal mode
keymap("i", "jj", "<ESC>")
keymap("t", "jj", "<C-\\><C-n>")
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')

-- Move Lines
-- keymap("n", "<C-j>", "<cmd>m .+1<CR>==")
-- keymap("v", "<C-j>", "<cmd>m '>+1<CR>gv=gv")
-- keymap("i", "<C-j>", "<Esc><cmd>m .+1<CR>==gi")
-- keymap("n", "<C-k>", "<cmd>m .-2<CR>==")
-- keymap("v", "<C-k>", "<cmd>m '<-2<CR>gv=gv")
-- keymap("i", "<C-k>", "<Esc><cmd>m .-2<CR>==gi")

-- Move in insert mode with using the arrow keys
keymap("i", "<C-k>", "<Up>")
keymap("i", "<C-j>", "<Down>")

keymap("i", "<C-h>", "<Left>")
keymap("i", "<C-l>", "<Right>")

-- Resize window using <shift> arrow keys
keymap("n", "<S-Up>", "<cmd>resize +2<CR>")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>")
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- useful
keymap("n", "H", "^")
keymap("n", "L", "$")
keymap("n", "Q", "@")

-- insert blank lines above and below
keymap("n", "[<space>", "O<esc>", { desc = "Pad above" })
keymap("n", "]<space>", "o<esc>", { desc = "Pad below" })

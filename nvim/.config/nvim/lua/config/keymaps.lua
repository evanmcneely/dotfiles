-- delete defaults https://www.lazyvim.org/configuration/general#keymaps
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "<leader>fn") -- neww file
vim.keymap.del("n", "<leader>ft") -- terminal
vim.keymap.del("n", "<leader>fT") -- terminal
vim.keymap.del("n", "<leader>gg") -- lazygit
vim.keymap.del("n", "<leader>gG") -- lazygit
vim.keymap.del("n", "<leader>-") -- split window down
vim.keymap.del("n", "<leader>|") -- split window vert
vim.keymap.del("n", "<leader>`") -- next buffer
vim.keymap.del("n", "<leader>L") -- Lazy
vim.keymap.del("n", "<leader>l") -- Lazy

-- Better escape using jj in insert and terminal mode
-- vim.keymap.set("i", "jj", "<ESC>")
-- vim.keymap.set("t", "jj", "<C-\\><C-n>")

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
-- vim.keymap.set("i", "<C-k>", "<Up>")
-- vim.keymap.set("i", "<C-j>", "<Down>")
-- vim.keymap.set("i", "<C-h>", "<Left>")
-- vim.keymap.set("i", "<C-l>", "<Right>")

-- Resize window using <shift> arrow keys
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- formatting with a longer timeout
-- vim.keymap.set("n", "<leader>f", function()
--   vim.lsp.buf.format { timeout_ms = 3000 }
-- end, { desc = "Format" })

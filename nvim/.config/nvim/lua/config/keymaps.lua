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

-- remap move lines to Control
vim.keymap.del("n", "<A-j>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("v", "<A-k>")
vim.keymap.del("i", "<A-k>")
vim.keymap.set("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

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

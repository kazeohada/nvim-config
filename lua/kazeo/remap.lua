vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Explore)
vim.keymap.set({'n', 'v'}, 'Y', '"+y', { noremap = true })
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

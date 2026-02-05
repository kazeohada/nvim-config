vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Explore)
vim.keymap.set({'n', 'v'}, 'Y', '"+y', { noremap = true })


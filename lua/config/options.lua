vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false

if vim.fn.has("win32") == 0 then
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "80"

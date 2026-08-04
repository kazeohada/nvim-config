-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function get_visual_selection()
  local reg_save = vim.fn.getreg("z")
  local regtype_save = vim.fn.getregtype("z")
  vim.cmd('noautocmd normal! "zy')
  local text = vim.fn.getreg("z")
  vim.fn.setreg("z", reg_save, regtype_save)
  return text
end

vim.keymap.set({'n', 'v'}, 'Y', '"+y', { noremap = true })
vim.keymap.set("v", "<leader>f", function()
  local text = get_visual_selection()
  vim.fn.setreg("/", vim.fn.escape(text, [[\/.*$^~[]]))
  vim.cmd("normal! n")
end, { desc = "Search visual selection in file" })
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

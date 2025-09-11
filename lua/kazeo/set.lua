function getOS()
	-- ask LuaJIT first
	if jit then
		return jit.os
	end

	-- Unix, Linux variants
	local fh,err = assert(io.popen("uname -o 2>/dev/null","r"))
	if fh then
		osname = fh:read()
	end

	return osname or "Windows"
end

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false

if getOS() ~= "Windows" then --TODO do something about this if you're bothered
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.colorcolumn = "80"

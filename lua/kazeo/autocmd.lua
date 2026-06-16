vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        local cwd = vim.fn.getcwd()
        local hash = vim.fn.system("echo " .. vim.fn.shellescape(cwd) .. " | md5 -q"):gsub("%s+$", "")
        local lock_file = "/tmp/claude-nvim-login-" .. hash
        os.remove(lock_file)
    end,
})

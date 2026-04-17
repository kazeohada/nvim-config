vim.keymap.set("n", "<leader>gs", function()
    local buf = vim.fn.bufnr("fugitive://")
    if buf ~= -1 and vim.fn.bufwinnr(buf) ~= -1 then
        vim.cmd("bdelete " .. buf)
    else
        vim.cmd.Git()
    end
end, { desc = "Toggle Fugitive" })

vim.keymap.set("n", "<leader>gc", function() vim.cmd("Git commit") end, { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", function() vim.cmd("Git push") end, { desc = "Git push" })

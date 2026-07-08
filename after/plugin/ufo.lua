vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match('^diffview://') or buftype == 'nofile' then
            return ''
        end
        return { 'lsp', 'indent' }
    end
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>ft', builtin.git_files, { desc = 'Telescope find files in git' })

vim.keymap.set('n', '<leader>fg', function()
    builtin.live_grep({
        additional_args = function()
          return { "--hidden" }
        end
    })
end, { desc = 'Telescope live grep' })

vim.keymap.set('n', '<leader>fr', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Telescope find files in project' })

vim.keymap.set('n', 'gr', function()
    require("telescope.builtin").lsp_references({ include_declaration = false });
end, { desc = 'LSP References' })

local telescope = require('telescope')
telescope.setup({
    defaults = {
        sorting_strategy = 'ascending',
        path_display = { 'truncate' },
        scroll_strategy = 'limit',
        selection_strategy = 'closest',
        -- Don't suggest binary files
        file_ignore_pattherns = {
            '/build', '/bin/', '/e%-bin/', '/lib/',
            '%.zip$', '%.tgz$', '%.gz$',
            '%.jpeg$', '%.jpg$', '%.png$', '%.bmp$', '%.ico$', '%.gif$',
            '%.jar$', '%.dll$', '%.so', '%.dylib',
        },
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>pr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>do', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>vsg', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>vsi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>vsd', builtin.lsp_definitions, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)


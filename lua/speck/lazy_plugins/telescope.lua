-- Windowing system for searching through something and picking an item.

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-live-grep-args.nvim',
        'olimorris/persisted.nvim',
    },

    config = function()
        local telescope = require('telescope')
        telescope.setup({
            defaults = {
                sorting_strategy = 'ascending',
                path_display = { 'truncate' },
                scroll_strategy = 'limit',
                selection_strategy = 'closest',
                -- Don't suggest binary files
                file_ignore_patterns = {
                    '/build', '/bin/', '/e%-bin/', '/lib/',
                    '%.zip$', '%.tgz$', '%.gz$',
                    '%.jpeg$', '%.jpg$', '%.png$', '%.bmp$', '%.ico$', '%.gif$',
                    '%.jar$', '%.dll$', '%.so', '%.dylib',
                    '%.class$',
                },
            },

            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown {
                    },
                },

                persisted = {
                    layout_config = {
                        width = 0.55,
                        height = 0.55,
                    },
                },
            },

            pickers = {
                lsp_document_symbols = {
                    theme = "dropdown",
                },
            },
        })

        telescope.load_extension('ui-select')
        telescope.load_extension('live_grep_args')
        telescope.load_extension('persisted')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>pr', builtin.lsp_references, {})
        vim.keymap.set('n', '<leader>po', builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<leader>pi', builtin.lsp_incoming_calls, {})
        vim.keymap.set('n', '<leader>pm', builtin.lsp_implementations, {})
        vim.keymap.set('n', '<leader>pd', builtin.lsp_definitions, {})
        vim.keymap.set('n', '<leader>ps', function()
            telescope.extensions.live_grep_args.live_grep_args()
        end)
    end
}

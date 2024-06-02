-- Windowing system for searching through something and picking an item.

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-live-grep-args.nvim',
        'olimorris/persisted.nvim',

        -- Optional, native, in-process implementation of fzf.
        -- Compiled on Windows with llvm (installed via scoop) using these steps:
        -- 1. Modify src/fzf.h and prefix all function definitions with __declspec(dllexport)
        -- 2. Compile:
        --    $ clang -O3 -D _CRT_SECURE_NO_WARNINGS -D _CRT_NONSTDC_NO_DEPRECATE -D _CRT_SECURE_NO_DEPRECATE -Wall -Werror -std=c99 -shared .\fzf.c -o libfzf.dll
        -- 3. Place the output in ~\AppData\Local\nvim-data\lazy\telescope-fzf-native.nvim\build\
        --    libfzf.dll, libfzf.exp, libfzf.lib
        'nvim-telescope/telescope-fzf-native.nvim',
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

                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
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
        telescope.load_extension('fzf')

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

-- Status line showing file opened, git status, diagnostics, cursor position, etc.

return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        require('lualine').setup {
            options = {
                -- Have a single status line and not one-per-window.
                globalstatus = true,
                -- Don't update status bar when in the NvimTree. This results in having
                -- the status bar keep the current buffer filename listed rather than
                -- 'NvimTree_1' when focus is in the tree.
                ignore_focus = { 'NvimTree' },
                theme = 'auto',
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff' },
                lualine_c = {
                    {
                        'filename',
                        path = 1, -- Relative path
                        symbols = {
                            modified = "[*]",
                            readonly = "[r]",
                        },
                    },
                    'filetype',
                },
                lualine_x = { 'searchcount', 'selectioncount', 'diagnostics' },
                lualine_y = { 'encoding', 'fileformat' },
                lualine_z = { 'location' }
            },
        }
    end
}

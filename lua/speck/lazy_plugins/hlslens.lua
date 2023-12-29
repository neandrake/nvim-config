-- Highlighted search results, with virtual text and easier navigation.
-- This plugin requires `hlsearch` to be on/true.

return {
    'kevinhwang91/nvim-hlslens',
    dependencies = {
        'petertriho/nvim-scrollbar',
    },

    config = function()
        require('scrollbar.handlers.search').setup({
            auto_enable = true,
            calm_down = true,
        })

        local kopts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap('n', 'n',
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts)
        vim.api.nvim_set_keymap('n', 'N',
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts)
        vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
        vim.api.nvim_set_keymap('n', '<leader>l', '<Cmd>noh<CR>', kopts)
    end,
}

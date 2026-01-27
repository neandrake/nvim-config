-- View and manage undo/redo as a tree of changes.

return {
    'jiaoshijie/undotree',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    config = function()
        local undotree = require('undotree')
        undotree.setup({
            float_diff = true,
            position = "left",
            ignore_filetype = {
                'undotree',
                'undotreeDiff',
                'qf',
                'TelescopePrompt',
                'spectre_panel',
                'tsplayground',
                'NvimTree',
            },
            window = {
                width = 0.15,
                -- Make the popup diff window not transparent at all.
                winblend = 0,
            },
        })

        vim.keymap.set("n", "<leader>u", undotree.toggle, { noremap = true, silent = true, })
    end,
}

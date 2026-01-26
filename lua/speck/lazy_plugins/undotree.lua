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

            keymaps = {
                ["j"] = "move_next",
                ["k"] = "move_prev",
                ["gj"] = "move2parent",
                ["J"] = "move_change_next",
                ["K"] = "move_change_prev",
                ["<cr>"] = "action_enter",
                ["p"] = "enter_diffbuf", -- this can switch between preview and undotree window
                ["q"] = "quit",
                ["S"] = "update_undotree_view",
            },
        })
    end,

    keys = {
        { '<leader>u', '<cmd>lua require("undotree").toggle()<cr>' },
    },
}

-- Workspace diagnostics window.

return {
    'folke/trouble.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    cmd = "Trouble",
    opts = {
        mode = "my_default",
        multiline = true,    -- Render multi-line messages.
        auto_open = false,   -- Automatically open the list when there are diagnostics.
        auto_close = false,  -- Automatically close the list when there are no diagnostics.
        auto_preview = true, -- Automatically preview the location of the diagnostic.

        -- Automatically jump if there's only a single result.
        auto_jump = true,

        -- Define custom "modes".
        modes = {
            my_default = {
                mode = "diagnostics",
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.3,
                },
            },
        },
    },

    keys = {
        {
            "<leader>td",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>tD",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
    },
}

-- Workspace diagnostics window.

return {
    'folke/trouble.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    cmd = "Trouble",
    opts = {
        mode = "my_default",
        multiline = false,   -- Do not render multi-line messages.
        auto_open = false,   -- Automatically open the list when there are diagnostics.
        auto_close = false,  -- Automatically close the list when there are no diagnostics.
        auto_preview = true, -- Automatically preview the location of the diagnostic.

        -- Automatically jump if there's only a single result.
        auto_jump = true,

        -- Define custom "modes".
        modes = {
            my_mode = {
                -- Inherit from the built-in 'diagnostics' mode.
                mode = "diagnostics",
                -- Embed the preview on the right-side of the trouble pane.
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.3,
                },
                -- Filter out diagnostics by severity, so they won't show intermixed.
                filter = function(items)
                    local severity = vim.diagnostic.severity.HINT
                    for _, item in ipairs(items) do
                        severity = math.min(severity, item.severity)
                    end
                    return vim.tbl_filter(function(item)
                        return item.severity == severity
                    end, items)
                end,
            },
        },
    },

    keys = {
        {
            "<leader>td",
            "<cmd>Trouble diagnostics toggle mode=my_mode<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>tD",
            "<cmd>Trouble diagnostics toggle mode=my_mode filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
    },
}

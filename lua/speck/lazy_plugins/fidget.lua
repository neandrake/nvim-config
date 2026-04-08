-- Display status of LSP server state.

return {
    'j-hui/fidget.nvim',

    config = function()
        require('fidget').setup({
            notification = {
                window = {
                    border = "single",
                    align = "top",
                    winblend = 0,
                    x_padding = 1,
                    y_padding = 1,

                    avoid = {
                        "NvimTree",
                    },
                },

                view = {
                    stack_upwards = false,
                },
            },
        })
    end,
}

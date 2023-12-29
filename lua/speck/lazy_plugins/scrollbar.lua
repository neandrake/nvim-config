-- Scrollbars

return {
    'petertriho/nvim-scrollbar',

    config = function()
        require('scrollbar').setup({
            set_highlights = true,
            handle = {
                highlight = "WildMenu",
            },
            marks = {
                Search = { highlight = "GruvboxOrange" },
                Error = { highlight = "DiagnosticError" },
                Warn = { highlight = "DiagnosticWarn" },
                Info = { highlight = "DiagnosticInfo" },
                Hint = { highlight = "DiagnosticHint" },
                Misc = { highlight = "GruvboxPurple" },
            }
        })
    end,
}

-- Scrollbars

return {
    'petertriho/nvim-scrollbar',

    config = function()
        -- TODO: Figure out the right migration and means of using gruvbox theme
        -- https://github.com/petertriho/nvim-scrollbar/blob/refactor/v2/docs/migration.md
        vim.g.scrollbar_v2_notice = false
        require('scrollbar').setup({
            set_highlights = true,
            scrollbar = {
                thumb = {
                    highlight = { bg = "WildMenu" },
                },
            },
            marks = {
                Search = { highlight = { fg = "GruvboxOrange" } },
                Error = { highlight = { fg = "DiagnosticError" } },
                Warn = { highlight = { fg = "DiagnosticWarn" } },
                Info = { highlight = { fg = "DiagnosticInfo" } },
                Hint = { highlight = { fg = "DiagnosticHint" } },
                Misc = { highlight = { fg = "GruvboxPurple" } },
            }
        })
    end,
}

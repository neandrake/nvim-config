-- LSP highlight of what's under cursor

return {
    'RRethy/vim-illuminate',

    config = function()
        require('illuminate').configure({
            -- ordered preference of provider for locating matches
            providers = {
                'lsp',
                'treesitter',
                'regex',
            },

            -- delay in millis
            delay = 100,

            -- highlight the thing under cursor
            under_cursor = true,

            should_enable = function(bufnr)
                -- Disable highlight in prompts and non-buffers
                local buftype = vim.bo.buftype
                if buftype == 'prompt' or buftype == 'nofile' then
                    return false
                end
                return true
            end
        })

        local update_highlights = function()
            -- Base the foregrounds on existing diagnostic colors. The background
            -- from 'WildMenu' maps to `GruvBoxBg2`, one of only a few that do.
            -- GruvBoxBg0 and 1 do not stand out enough and 3-4 stand out too much.
            local bg = vim.api.nvim_get_hl(0, { name = "WildMenu", link = false }).bg;
            local text = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false }).fg;
            local read = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false }).fg;
            local write = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false }).fg;

            vim.api.nvim_set_hl(0, "IlluminatedWordText", {
                bg = bg,
                fg = text,
            })
            vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
                bg = bg,
                fg = read,
                italic = true,
            })
            vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
                bg = bg,
                fg = write,
                bold = true,
                underline = true,
            })
        end

        update_highlights()
        -- Update highlights after color themes are applied. If the color theme
        -- is applied after vim-illuminate loads then the above configuration
        -- will be overwritten.
        vim.api.nvim_create_autocmd({ "ColorScheme" }, {
            pattern = { "*" },
            callback = update_highlights,
        })
    end
}

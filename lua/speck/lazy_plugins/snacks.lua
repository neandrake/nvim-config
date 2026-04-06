return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<leader>ld",
            function()
                if Snacks.dim.enabled then Snacks.dim.disable() else Snacks.dim.enable() end
            end,
            desc = "Toggle scoped dimmer"
        },
    },
    opts = {
        -- Dim everything outside of the cursor's scope.
        dim = {
            enabled = true,
            animate = { enabled = false },
        },

        -- Show indentation guides.
        indent = {
            enabled = true,
            animate = { enabled = false },
        },

        -- LSP highlight of what's under cursor.
        words = {
            enabled = true,
            debounce = 100,
            filter = function(buf)
                -- Disable highlight in prompts and non-buffers
                local buftype = vim.bo.buftype
                if buftype == 'prompt' or buftype == 'nofile' then
                    return false
                end
                return true
            end,
            config = function()
                local update_highlights = function()
                    -- Base the foregrounds on existing diagnostic colors. The background
                    -- from 'WildMenu' maps to `GruvBoxBg2`, one of only a few that do.
                    -- GruvBoxBg0 and 1 do not stand out enough and 3-4 stand out too much.
                    local bg = vim.api.nvim_get_hl(0, { name = "WildMenu", link = false }).bg;
                    local text = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo", link = false }).fg;
                    local read = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false }).fg;
                    local write = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false }).fg;

                    -- Snacks.words uses the default highlighting of nvim's Lsp.
                    vim.api.nvim_set_hl(0, "LspReferenceText", {
                        bg = bg,
                        fg = text,
                    })
                    vim.api.nvim_set_hl(0, "LspReferenceRead", {
                        bg = bg,
                        fg = read,
                        italic = true,
                    })
                    vim.api.nvim_set_hl(0, "LspReferenceWrite", {
                        bg = bg,
                        fg = write,
                        bold = true,
                        underline = true,
                    })
                end

                update_highlights()
                -- Update highlights after color themes are applied. If the color theme
                -- is applied after Snacks loads then the above configuration will be overwritten.
                vim.api.nvim_create_autocmd({ "ColorScheme" }, {
                    pattern = { "*" },
                    callback = update_highlights,
                })
            end
        },
    },
}

require('illuminate').configure {
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
}

-- Switch to using visual block highlight instead of underline.
vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })

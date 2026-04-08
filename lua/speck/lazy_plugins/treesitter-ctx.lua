-- Core plugin that provides Treesitter API used by other plugins and also
-- provides some basic language-context functionality.

return {
    'nvim-treesitter/nvim-treesitter-context',

    config = function()
        -- Displays the scope/context (functions, classes, etc.) at the top of the
        -- buffer, for the current cursor location.
        local ts_ctx = require('treesitter-context')
        ts_ctx.setup {
            enable = true,
            -- Only show a max of 5 lines of context/scope otherwise it's overwhelming
            -- and hides contextually-relevant code near the cursor.
            max_lines = 5,
            -- When max_lines is reached trim the inner scope and show the outer scope,
            -- as it's more likely the inner scope is more easily accessible through
            -- navigation.
            trim_scope = 'inner',
            -- Either 'cursor' or 'topline', specifies which to use for relative scope.
            -- Using 'cursor' causes the context to change while moving around, which
            -- is distracting.
            mode = 'topline',

            on_attach = function(buf)
                -- The treesitter-context behavior requires modifying the buffer.
                if not vim.bo[buf].modifiable then
                    return false
                end
                -- Disable attaching to prompts or non-file buffers.
                local buftype = vim.bo[buf].buftype
                if buftype == 'prompt' or buftype == 'nofile' then
                    return false
                end
            end,
        }

        vim.keymap.set("n", "gc", function() ts_ctx.go_to_context() end, { silent = true })
    end
}

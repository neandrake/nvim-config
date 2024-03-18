-- Tree-based file system explorer, to replace vim's netrw.

return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        require('nvim-tree').setup {
            sort_by = "case_sensitive",

            -- Turn off hijacking netrw behaviors as it interferes with `persist` plugin
            -- saving and restoring state of the session.
            -- netrw is disabled in core/set.lua.
            hijack_netrw = false,
            hijack_unnamed_buffer_when_opening = false,

            -- Turn on diagnostics/lsp integration.
            diagnostics = {
                enable = true,
            },
            -- Turn on modification tracking, to see what files are opened & modified.
            modified = {
                enable = true,
            },
            -- Turn off git integration, which tends to get crashy when mixed with heavy
            -- LSP servers.
            git = {
                enable = false,
            },

            view = {
                width = 30,
            },

            renderer = {
                -- Compact folders with single sub-folders.
                group_empty = true,
                -- Show full file name in tooltip when highlighted.
                full_name = true,
                -- Highlight files with LSP diagnostics errors.
                highlight_diagnostics = true,
                -- Highlight files modified in buffers.
                highlight_modified = "icon",
            },

            -- Files not to show in the tree.
            filters = {
                git_ignored = true,
            },
        }

        local api = require('nvim-tree.api')
        vim.keymap.set("n", "<leader>tt", api.tree.toggle)
        vim.keymap.set("n", "<leader>tf", function()
            -- Collapse all folders, select & expand for current buffer. Different from
            -- collapse_all(true) in that it works for current buffer, not all opened.
            api.tree.collapse_all(false)
            api.tree.find_file()
        end)
        vim.keymap.set("n", "<leader>tr", api.tree.reload)
    end
}

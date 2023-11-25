require('nvim-tree').setup {
    sort_by = "case_sensitive",

    -- Turn on diagnostics/lsp integration.
    diagnostics = {
        enable = true,
    },
    -- Turn on modification tracking, to see what files are opened & modified.
    modified = {
        enable = true,
    },
    -- Turn on git integration, to not show files ignored by .gitignore.
    git = {
        enable = true,
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
vim.keymap.set("n", "<leader>tf", api.tree.find_file)
vim.keymap.set("n", "<leader>tc", function()
    -- Collapse all folders, select & expand for current buffer. Different from
    -- collapse_all(true) in that it works for current buffer, not all opened.
    api.tree.collapse_all(false)
    api.tree.find_file()
end)
vim.keymap.set("n", "<leader>tr", api.tree.reload)

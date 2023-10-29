require('nvim-tree').setup {
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
}

local api = require('nvim-tree.api')
vim.keymap.set("n", "<leader>tt", api.tree.toggle)
vim.keymap.set("n", "<leader>tf", api.tree.find_file)


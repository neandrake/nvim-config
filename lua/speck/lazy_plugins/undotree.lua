-- View and manage undo/redo as a tree of changes.

return {
    'mbbill/undotree',

    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
}


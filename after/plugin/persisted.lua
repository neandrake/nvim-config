local persisted = require('persisted')

-- Note: Refer to `set.lua` where `vim.opt.sessionoptions` is specified which
-- indicates what gets saved in a session.

persisted.setup({
    use_git_branch = true,
    default_brance = "main",

    autosave = true,
    autoload = true,
})

local persisted_hook_group = vim.api.nvim_create_augroup("PersistedHooks", {})

-- AutoCmd to hook into the pre-save callback, to close NvimTree and Trouble
-- so their state is not persisted with the session.
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedSavePre",
    group = persisted_hook_group,
    callback = function()
        pcall(vim.cmd, "NvimTreeClose")
        pcall(vim.cmd, "TroubleClose")
    end,
})
-- Hook into post-save to re-open NvimTree and Trouble.
-- XXX: How to get and restore their state between these callbacks?
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedSavePost",
    group = persisted_hook_group,
    callback = function()
        pcall(vim.cmd, "NvimTreeOpen")
        -- Don't turn on Trouble after saving. It's likely more annoying to have
        -- this suddenly appear than for it to disappear if open.
        --pcall(vim.cmd, "Trouble")
    end,
})
-- Hook into post-load to turn on NvimTree
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedLoadPost",
    group = persisted_hook_group,
    callback = function()
        pcall(vim.cmd, "NvimTreeOpen")
    end,
})

-- Hook into loading from telescope, to save the current session and close all
-- buffers prior to loading the session selected within Telescope.
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedTelescopeLoadPre",
    group = persisted_hook_group,
    callback = function()
        -- Save the currently loaded session
        persisted.save({ session = vim.g.persisted_loaded_session })

        -- Close all opened buffers in prep for loading the session selected.
        vim.api.nvim_input("<ESC>:%bd!<CR>")
    end,
})

local persisted = require('persisted')

-- Note: Refer to `set.lua` where `vim.opt.sessionoptions` is specified which
-- indicates what gets saved in a session.

persisted.setup({
    use_git_branch = true,
    default_branch = "main",

    autosave = true,
    autoload = true,
})

local nvimtree = require('nvim-tree.api')
local trouble = require('trouble')
local persisted_hook_group = vim.api.nvim_create_augroup("PersistedHooks", {})

-- Track the state of NvimTree and Trouble during a save. These windows/buffers
-- are closed prior to saving state, so they are not part of the session state
-- persisted to disk.
local nvim_transient_save_state = {
    is_nvimtree_open = false,
    is_trouble_open = false,
}

function nvim_transient_save_state.capture()
    nvim_transient_save_state.is_nvimtree_open = nvimtree.tree.is_visible()
    nvim_transient_save_state.is_trouble_open = trouble.is_open()
end

function nvim_transient_save_state.restore()
    if nvim_transient_save_state.is_nvimtree_open then
        nvimtree.tree.open()
    end
    if nvim_transient_save_state.is_trouble_open then
        trouble.open()
    end
    vim.api.nvim_command("redraw")
end

-- Hook into the pre-save callback, to close NvimTree and Trouble so their state
-- is not persisted with the session.
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedSavePre",
    group = persisted_hook_group,
    callback = function()
        nvim_transient_save_state.capture()
        nvimtree.tree.close()
        trouble.close()
    end,
})
-- Hook into post-save to re-open NvimTree and Trouble.
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedSavePost",
    group = persisted_hook_group,
    callback = nvim_transient_save_state.restore,
})
-- Hook into autosave starting, which will occur regardless of whether a session
-- was loaded as long as autosave is enabled.
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedStateChange",
    group = persisted_hook_group,
    callback = function()
        nvimtree.tree.open()
        vim.api.nvim_command("redraw")
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

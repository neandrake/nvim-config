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

-- Filter to find windows whose current/main buffer is not NvimTree or Trouble.
local function nvimtree_win_filter(win)
    local curbuf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.api.nvim_buf_get_option(curbuf, 'filetype')

    if filetype == 'NvimTree' or filetype == 'Trouble' then return false end

    return true
end

-- Find the first non-NvimTree and non-Trouble window and set focus to it.
local function focus_main_window()
    local wins = vim.tbl_filter(nvimtree_win_filter, vim.api.nvim_list_wins())
    for _, win in ipairs(wins) do
        vim.api.nvim_set_current_win(win)
        break
    end
end

function nvim_transient_save_state.restore()
    if nvim_transient_save_state.is_nvimtree_open then
        nvimtree.tree.open()
    end
    if nvim_transient_save_state.is_trouble_open then
        trouble.open()
    end
    focus_main_window()
    vim.api.nvim_command("redraw")
end

-- Filter to find buffers to be closed pre/post load/save. This should return
-- true for any buffer that isn't for a file/text-editing.
local function nonpersisted_buffer_filter(buf)
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_get_option(buf, 'buflisted') then
        return false
    end

    -- netrw is disabled but just in case.
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    if filetype == 'netrw' then return true end

    -- Non-file buffers and prompts are sometimes tagged as such.
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    if buftype == 'nofile' or buftype == 'prompt' then return true end

    -- Check if the buffer's name is a directory, which if so is likely some
    -- extraneous buffer from having opened Neovim with a directory argument.
    local name = vim.api.nvim_buf_get_name(buf)
    local path = vim.loop.fs_realpath(vim.fn.expand(name))
    if path == nil then return false end
    return vim.fn.isdirectory(path) ~= 0
end

-- Gets a list of buffers that are valid/listed and are for a directory, and
-- deletes them.
local function close_dir_buffers()
    -- Delete each buffer that passes the filter.
    local buffers_to_del = vim.tbl_filter(nonpersisted_buffer_filter, vim.api.nvim_list_bufs())
    for _, buffer in ipairs(buffers_to_del) do
        vim.api.nvim_buf_delete(buffer, {})
    end
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
        focus_main_window()
        vim.api.nvim_command("redraw")
    end,
})
-- Delete buffers for directories after load.
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "PersistedLoadPost",
    group = persisted_hook_group,
    callback = function()
        close_dir_buffers()
        focus_main_window()
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

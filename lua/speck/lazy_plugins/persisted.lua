-- Session management. This plugin/behavior handles the initial windowing/layout
-- regardless of sessions being used.

return {
    'olimorris/persisted.nvim',

    config = function()
        local persisted = require('persisted')
        local nvimtree = require('nvim-tree.api')
        local trouble = require('trouble')

        -- Note: Refer to `set.lua` where `vim.opt.sessionoptions` is specified which
        -- indicates what gets saved in a session.

        -- Find the first non-NvimTree and non-Trouble window and set focus to it.
        local function focus_main_window()
            -- Filter to find windows whose current/main buffer is not NvimTree or Trouble.
            local function nvimtree_win_filter(win)
                local curbuf = vim.api.nvim_win_get_buf(win)
                local filetype = vim.api.nvim_get_option_value('filetype', { buf = curbuf })

                if filetype == 'NvimTree' or filetype == 'Trouble' then return false end

                return true
            end

            local wins = vim.tbl_filter(nvimtree_win_filter, vim.api.nvim_list_wins())
            for _, win in ipairs(wins) do
                vim.api.nvim_set_current_win(win)
                break
            end
        end

        -- Gets a list of buffers that are valid/listed and are for a directory, and
        -- deletes them.
        local function close_dir_buffers()
            -- Filter to find buffers to be closed pre/post load/save. This should return
            -- true for any buffer that isn't for a file/text-editing.
            local function buffer_filter(buf)
                if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_get_option_value('buflisted', { buf = buf }) then
                    return false
                end

                -- netrw is disabled but just in case.
                local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
                if filetype == 'netrw' then return true end

                -- Non-file buffers and prompts are sometimes tagged as such.
                local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
                if buftype == 'nofile' or buftype == 'prompt' then return true end

                -- Check if the buffer's name is a directory, which if so is likely some
                -- extraneous buffer from having opened Neovim with a directory argument.
                local name = vim.api.nvim_buf_get_name(buf)
                local path = vim.loop.fs_realpath(vim.fn.expand(name))
                if path == nil then return false end
                return vim.fn.isdirectory(path) ~= 0
            end

            -- Delete each buffer that passes the filter.
            local buffers_to_del = vim.tbl_filter(buffer_filter, vim.api.nvim_list_bufs())
            local buffers_changed = false
            for _, buffer in ipairs(buffers_to_del) do
                vim.api.nvim_buf_delete(buffer, {})
                buffers_changed = true
            end
            if buffers_changed then
                vim.api.nvim_command("redraw")
            end
        end

        local function open_nvimtree()
            if not nvimtree.tree.is_visible() then
                nvimtree.tree.open()
                vim.api.nvim_command("redraw")
            end
        end

        persisted.setup({
            use_git_branch = true,

            autostart = true,
            autoload = true,

            -- Save sessions for anything under ~/Source where most of my projects are,
            -- and other folders where I commonly work.
            allowed_dirs = {
                '~/Source',
                '~/.config',
                '~/AppData',
            },

            on_autoload_no_session = function()
                open_nvimtree()
                focus_main_window()
            end,
        })

        -- Persisted does not autoload unless nvim is opened with a file. This
        -- will force auto-loading if nvim has no arguments or is passed a
        -- single argument that is a directory, otherwise persisted will kick in
        -- like normal.
        --[[
        vim.api.nvim_create_autocmd("VimEnter", {
            nested = true,

            callback = function()
                if vim.g.started_with_stdin then
                    return
                end

                local forceload = false
                if vim.fn.argc() == 0 then
                    forceload = true
                elseif vim.fn.argc() == 1 then
                    local dir = vim.fn.expand(vim.fn.argv(0))
                    if dir == '.' then
                        dir = vim.fn.getcwd()
                    end

                    if vim.fn.isdirectory(dir) ~= 0 then
                        forceload = true
                    end
                end

                persisted.autoload({ force = forceload })
            end,
        })
        ]]--

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
            local window_toggled = false
            if nvim_transient_save_state.is_nvimtree_open and not nvimtree.tree.is_visible() then
                nvimtree.tree.open()
                window_toggled = true
            end
            if nvim_transient_save_state.is_trouble_open and not trouble.is_open() then
                trouble.open()
                window_toggled = true
            end
            focus_main_window()
            if window_toggled then
                vim.api.nvim_command("redraw")
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
        -- Delete buffers for directories after load.
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "PersistedLoadPost",
            group = persisted_hook_group,
            callback = function()
                close_dir_buffers()
                focus_main_window()
            end,
        })
        -- Hook into autosave starting, which will occur regardless of whether a session
        -- was loaded as long as autosave is enabled.
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "PersistedStart",
            group = persisted_hook_group,
            callback = function()
                -- Schedule the default state. The LoadPre/LoadPost events are
                -- invoked via vim.schedule, and this must happen after those fire.
                -- https://github.com/olimorris/persisted.nvim/pull/178
                vim.schedule(function()
                    open_nvimtree()
                    focus_main_window()
                end)
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
    end
}

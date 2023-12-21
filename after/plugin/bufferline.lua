local bufline = require('bufferline')
bufline.setup({
    options = {
        mode = 'buffers',
        numbers = 'buffer_id',
        separator_style = 'slant',
        indicator = {
            style = 'underline',
        },

        --[[
        custom_filter = function(buffer_id)
            local buf = vim.bo[buffer_id]

            if buf.filetype == 'netrw' or buf.filetype == 'NvimTree' then
                return false
            end

            if buf.buftype == 'nofile' or buf.buftype == 'prompt' then
                return false
            end

            local bufname = vim.api.nvim_buf_get_name(buffer_id)
            if vim.fn.isdirectory(bufname) ~= 0 then
                return false
            end

            return true
        end,
        ]]--

        hover = {
            enabled = true,
            delay = 100,
            reveal = { 'close' },
        },

        -- Offsets the buffer tabs to not span across the NvimTree sidebar.
        -- Note the nested object structure here. The documentation in `:help bufferline-offset`
        -- demonstrates using this nested object though it looks like a bug.
        offsets = { {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
        } }
    },
})

vim.keymap.set("n", "<leader>gb", function() bufline.pick() end)
-- It's not possible to map Ctrl+[num], some F[num] keys seem to already be mapped for LSP
--[[
vim.keymap.set("n", "<F1>", function() bufline.go_to(1) end)
vim.keymap.set("n", "<F2>", function() bufline.go_to(2) end)
vim.keymap.set("n", "<F3>", function() bufline.go_to(3) end)
vim.keymap.set("n", "<F4>", function() bufline.go_to(4) end)
vim.keymap.set("n", "<F5>", function() bufline.go_to(5) end)
vim.keymap.set("n", "<F6>", function() bufline.go_to(6) end)
]]--

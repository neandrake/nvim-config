-- Tabs for buffers

return {
    'akinsho/bufferline.nvim',
    version = 'v4.4.*',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        local bufline = require('bufferline')
        local bufdel = require('bufdelete')
        bufline.setup({
            options = {
                mode = 'buffers',
                separator_style = 'slant',
                indicator = {
                    style = 'icon',
                },
                buffer_close_icon = '',
                close_command = bufdel.bufdelete,

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

        -- Switch buffer, close current buffer
        vim.keymap.set("n", "<C-s>", function() bufline.pick() end)
        vim.keymap.set("n", "<C-x>", function() bufdel.bufdelete(0) end)
    end,
}

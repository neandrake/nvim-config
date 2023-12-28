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
                numbers = function(opts)
                    return string.format('%s', opts.lower(opts.id))
                end,
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

        vim.keymap.set("n", "<leader>gb", function() bufline.pick() end)
        -- It's not possible to map Ctrl+[num], some F[num] keys seem to already be mapped for LSP
        --[[
        vim.keymap.set("n", "<F2>", function() bufline.go_to(2) end)
        vim.keymap.set("n", "<F1>", function() bufline.go_to(1) end)
        vim.keymap.set("n", "<F3>", function() bufline.go_to(3) end)
        vim.keymap.set("n", "<F4>", function() bufline.go_to(4) end)
        vim.keymap.set("n", "<F5>", function() bufline.go_to(5) end)
        vim.keymap.set("n", "<F6>", function() bufline.go_to(6) end)
        ]]--
    end,
}

-- Color theme
return {
    'ellisonleao/gruvbox.nvim',

    config = function()
        require('gruvbox').setup {
            --contrast = "hard",
        }

        vim.cmd.colorscheme('gruvbox')
    end
}

--[[
return {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.everforest_enable_italic = true
        vim.g.everforest_background = 'soft'
        vim.cmd.colorscheme('everforest')
    end
}
]]--


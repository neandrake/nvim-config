-- Color theme
return {
    'ellisonleao/gruvbox.nvim',

    config = function()
        require('gruvbox').setup {
            contrast = "hard",
        }

        vim.cmd('colorscheme gruvbox')
    end
}

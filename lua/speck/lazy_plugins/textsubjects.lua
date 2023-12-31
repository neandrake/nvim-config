-- Selection of treesitter node context (keymappings effective when in visual mode).

return {
    'RRethy/nvim-treesitter-textsubjects',

    config = function()
        require('nvim-treesitter.configs').setup {
            textsubjects = {
                enable = true,
                prev_selection = ',',
                keymaps = {
                    ['.'] = {
                        'textsubjects-smart',
                    },
                    [';'] = {
                        'textsubjects-container-outer',
                        desc = 'Select outer containers',
                    },
                    ['/'] = {
                        'textsubjects-container-inner',
                        desc = 'Select inner containers',
                    }
                }
            }
        }
    end,
}

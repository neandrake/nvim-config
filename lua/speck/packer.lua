-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    -- Fuzzy file finder
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = {
            'nvim-lua/plenary.nvim',
            'olimorris/persisted.nvim',
        },
    }
    use('nvim-telescope/telescope-ui-select.nvim')

    -- Color theme
    use('ellisonleao/gruvbox.nvim')

    -- Icons for file types added to the font/glyphs. This is used by other plugins.
    -- Do first-class install here instead of as dependency, so that all plugins can
    -- find it ('trouble' had difficulties locating/identifying it being installed).
    use('nvim-tree/nvim-web-devicons')

    -- Status line at bottom.
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }

    -- Abide .editorconfig settings
    use('gpanders/editorconfig.nvim')
    -- Treesitter for syntax highlighting, also ensure that tree-sitter parsers
    -- update when updating the nvim-treesitter plugin.
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    -- Treesitter context, to always show what scope you're in
    use('nvim-treesitter/nvim-treesitter-context')
    -- View and manage the undo tree, allows branching-like behavior with changes
    use('mbbill/undotree')

    -- LSP manager
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Fancy icons
            { 'onsails/lspkind.nvim' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    -- Improve VIM's default UI
    use('stevearc/dressing.nvim')

    -- Notifications UI
    use('rcarriga/nvim-notify')

    -- LSP Highlight of what's under cursor
    use('RRethy/vim-illuminate')

    -- Task Runner
    use('stevearc/overseer.nvim')

    -- Tree Browser
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        }
    }

    -- Tabs for buffers
    use {
        'akinsho/bufferline.nvim',
        tag = "v4.4.*",
        requires = {
            'nvim-tree/nvim-web-devicons',
        }
    }

    use {
        'famiu/bufdelete.nvim',
    }

    -- Session management
    use {
        'olimorris/persisted.nvim',
    }

    use {
        'folke/trouble.nvim',
        requires = {
            'nvim-tree/nvim-web-devicons',
        }
    }
end)

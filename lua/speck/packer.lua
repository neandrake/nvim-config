-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  -- Fuzzy file finder
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	  requires = {
          'nvim-lua/plenary.nvim',
      },
  }
  use('nvim-telescope/telescope-ui-select.nvim')

  -- Color theme
  use ('ellisonleao/gruvbox.nvim')
  --[[
  use {
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  }
  --]]

  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  }

  -- Abide .editorconfig settings
  use('gpanders/editorconfig.nvim')
  -- Treesitter for syntax highlighting
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  -- Treesitter context, to always show what scope you're in
  use('nvim-treesitter/nvim-treesitter-context')
  -- Harpoon for marking files in a list and switching between them
  use('theprimeagen/harpoon')
  -- View and manage the undo tree, allows branching-like behavior with changes
  use('mbbill/undotree')

  -- LSP manager
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
          {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

          -- Fancy icons
          {'onsails/lspkind.nvim'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
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
end)

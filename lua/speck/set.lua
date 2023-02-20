-- Use block cursor always (default insert mode is thin bar)
vim.opt.guicursor = ""

-- Turn on line numbers and use relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Use 4-space indents by default
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Turn off line wrapping
vim.opt.wrap = false

-- Turn off backup files but setup UndoTree plugin for infinite undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = (os.getenv('HOME') or os.getenv('LOCALAPPDATA')) .. '/.vim/undodir'
vim.opt.undofile = true

-- Highlight while typing search term but don't keep highlight turned on
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- Keep cursor 8 lines from top/bottom
vim.opt.scrolloff = 8

-- Show gutter for signs/icons
vim.opt.signcolumn = "yes"

-- ??
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "


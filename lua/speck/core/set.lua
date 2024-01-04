-- Use block cursor for most modes, underline for insert/replace
--vim.opt.guicursor = "n-v-c-ci-cr-o:block-Cursor,i-r-sm-:hor20"
-- Use block cursor for most modes, vertical line for inserts, horizontal for replace
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

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

-- Turn on hlsearch and incsearch as it will be taken over by hlslens plugin.
-- Without that plugin prefer hlsearch off as it will retain highlighted instances.
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Disable netrw to avoid race conditions with nvim-tree and netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set termguicolors to enable highlight groups in nvim-tree
vim.opt.termguicolors = true

-- Keep cursor 8 lines from top/bottom
vim.opt.scrolloff = 8

-- Show gutter for signs/icons
vim.opt.signcolumn = "yes"

-- I think this allows `@` to appear in filenames.
vim.opt.isfname:append("@-@")

-- The ms to wait after inactivity for saving the swap file.
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- Integrate yank/delete/change/put with the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Specify what gets saved when saving sessions. Note that this omits 'blank'
-- which is part of vim's default options, and omits local/global options. If
-- those are saved then things like modifiable state are persisted restuling
-- in odd behavior, e.g. run `nvim -M` to open in read-only state, close session
-- then later open regularly without `-M` and the buffers will still be
-- read-only.
vim.opt.sessionoptions = "buffers,folds,tabpages,winpos,winsize"

vim.diagnostic.config({
    -- Disable showing diagnostics as virtual text directly in the buffer.
    virtual_text = false,
    -- Show higher severity issues over lower-severity ones.
    severity_sort = true,

    -- Configuration for the floating window showing diagnostics.
    float = {
        severity_sort = true,
    },
})

-- Disable providers that are unlikely to be installed w/ neovim module packages.
-- These are used for remote plugins (run in separate process), which I do not
-- make use of any.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

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

-- Rounded borders in floating windows.
vim.opt.winborder = 'rounded'

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
    -- Opt-in enable diagnostics in virtual line but only for the current line.
    -- Alternatively use virtual_text to have diagnostics appear as virtual text
    -- instead of virtual lines.
    virtual_text = {
        current_line = true,
    },

    -- Show higher severity issues over lower-severity ones.
    severity_sort = true,

    -- Configuration for the floating window showing diagnostics.
    float = {
        severity_sort = true,
    },

    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.INFO] = '»',
            [vim.diagnostic.severity.HINT] = '⚑',
        }
    },
})

-- Disable providers that are unlikely to be installed w/ neovim module packages.
-- These are used for remote plugins (run in separate process), which I do not
-- make use of any.
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Custom keys for LSP.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('speck.lsp', {}),
    callback = function(args)
        local opts = { buffer = 0, remap = false }

        local telescope = require('telescope.builtin')

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "ge", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "L", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>pt", function() telescope.lsp_dynamic_workspace_symbols() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>cn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format() end, opts)
        vim.keymap.set("v", "<leader>cf", function()
            -- This requires the LSP to support range format, which not all do.
            -- Consider hooking up stevearc/conform.nvim which includes other benefits.
            local range = {
                ['start'] = vim.fn.getpos('v'),
                ['end'] = vim.fn.getpos('.')
            }
            vim.lsp.buf.format({ range = range })
        end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
})

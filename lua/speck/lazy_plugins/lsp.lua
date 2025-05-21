-- Management of both LSP servers and auto-completion.
-- The "root" or main plugin for managing these are nvim-cmp for auto-complete
-- and nvim-lspconfig for LSP. Each have additional dependencies which
return {
    -- Rust: simplifies the configuration for an enriched LSP/DAP experience.
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        lazy = false, -- The plugin itself manages being lazy
    },

    --[[
    -- Java: simplifies the configuration for an enriched LSP/DAP experience.
    {
        'nvim-java/nvim-java',
        dependencies = {
            'nvim-java/lua-async-await',
            'nvim-java/nvim-java-refactor',
            'nvim-java/nvim-java-core',
            'nvim-java/nvim-java-test',
            'nvim-java/nvim-java-dap',
            'MunifTanjim/nui.nvim',
            'neovim/nvim-lspconfig',
            'mfussenegger/nvim-dap',
            {
                'williamboman/mason.nvim',
                opts = {
                    registries = {
                        'github:nvim-java/mason-registry',
                        'github:mason-org/mason-registry',
                    },
                },
            }
        },

        config = function()
            local java = require('java')
            java.setup()
        end,
    },
    ]]--

    -- ## Below are the core plugins used for managing LSP configs, LSP servers, and auto-complete ## --

    -- This is for easy LSP configuration functionality/utilities, and is used
    -- by both auto-completion and LSP, so defined here as a primary plugin
    -- to be installed. This is configured to essentially not trigger automatic
    -- setup like most plugins, and allow the auto-complete and LSP configurations
    -- to manage this instead.
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup.
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },

    -- Mason is a plugin for easily managing installations of LSP servers on the
    -- system. This is configured below to use nvim-lspconfig for providing it
    -- "registry" of LSP implementations that could be installed. Here Mason needs
    -- configured to eagerly initialize so it occurs before mason-lspconfig that
    -- is set up below as part of nvim-lspconfig. See also :h mason-lspconfig-quickstart.
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    -- nvim-cmp: Lua implementation of auto-completion. Uses the concept of sources
    --           or engines for providing the results.
    --           This also uses lsp-zero which provides an engine/source from an
    --           LSP connected with the current buffer.
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            -- Sources
            'hrsh7th/cmp-buffer',       -- Text in the current buffer.
            'hrsh7th/cmp-path',         -- File system paths.
            'saadparwaiz1/cmp_luasnip', -- Use LuaSnip as a source.
            'hrsh7th/cmp-nvim-lsp',     -- NeoVim's built-in LSP as a source.
            'hrsh7th/cmp-nvim-lua',     -- NeoVim's Lua API as a source.

            -- Snippets
            'L3MON4D3/LuaSnip', --  Snippet engine.

            -- UI
            'onsails/lspkind.nvim', -- Fancy icons.
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            local types = require('cmp.types')

            lsp_zero.extend_cmp()

            -- Sort Text last, Snippets second-last. Based on `cmp.config.compare.kind`.
            local sortby_kind = function(entry1, entry2)
                local kind1 = entry1:get_kind()
                local kind2 = entry2:get_kind()
                kind1 = kind1 == types.lsp.CompletionItemKind.Text and 200 or kind1
                kind2 = kind2 == types.lsp.CompletionItemKind.Text and 200 or kind2
                kind1 = kind1 == types.lsp.CompletionItemKind.Snippet and 100 or kind1
                kind2 = kind2 == types.lsp.CompletionItemKind.Snippet and 100 or kind2
                if kind1 ~= kind2 then
                    local diff = kind1 - kind2
                    if diff < 0 then
                        return true
                    elseif diff > 0 then
                        return false
                    end
                end
                return nil
            end

            local select_opts = {
                behavior = cmp.SelectBehavior.SelectBehavior,
            }

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-j>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<C-k>'] = cmp.mapping.select_next_item(select_opts),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<ESC>'] = cmp.mapping.abort(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<Tab>'] = nil,
                    ['<S-Tab>'] = nil,
                }),
                enabled = function()
                    -- Disable completion in prompts and non-buffers
                    local buftype = vim.bo.buftype
                    if buftype == 'prompt' or buftype == 'nofile' then
                        return false
                    end
                    -- Disable completion when typing in a comment
                    local context = require('cmp.config.context')
                    if context.in_treesitter_capture('comment') or context.in_syntax_group('Comment') then
                        -- Continue to allow completion when in command-mode
                        return vim.api.nvim_get_mode().mode == 'c'
                    end
                    return true
                end,
                preselect = 'item',
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        sortby_kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                formatting = {
                    -- Change order of fields so the icon is first
                    fields = { 'kind', 'menu', 'abbr' },
                    format = function(entry, item)
                        local rendered = lspkind.cmp_format({
                            mode = 'symbol_text',
                            maxwidth = 50,
                            ellipsis_char = '...',
                        })(entry, item)

                        local strings = vim.split(rendered.kind, '%s', { trimempty = true })
                        rendered.kind = ' ' .. (strings[1] or '') .. ' '
                        rendered.menu = '(' .. (strings[2] or '') .. ')'
                        return rendered
                    end,
                },
                sources = cmp.config.sources({
                    {
                        name = 'nvim_lsp',
                        group_index = 1,
                    },
                    {
                        name = 'luasnip',
                        group_index = 2,
                        max_item_count = 5,
                    },
                    {
                        name = 'buffer',
                        group_index = 3,
                        max_item_count = 5,
                    },
                }),
                view = {
                    -- Use the default popup menu, but ensure the highest-scoring item
                    -- is near the cursor. The menu expands down by default but may
                    -- expand up depending where the cursor is located.
                    entries = { name = 'custom', selection_order = 'near_cursor' },
                    docs = {
                        auto_open = true,
                    },
                },
                -- See https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
                window = {
                    completion = cmp.config.window.bordered({
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    }),
                    documentation = cmp.config.window.bordered({
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    }),
                },
            })

            -- Highlights in the auto-complete menu. See:
            -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
            local update_highlights = function()
                -- gray
                vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
                -- blue
                vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
                vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
                -- light blue
                vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
                vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
                vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
                -- pink
                vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
                vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
                -- front
                vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
                vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
                vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })
            end

            update_highlights()
            vim.api.nvim_create_autocmd({ "ColorScheme" }, {
                pattern = { "*" },
                callback = update_highlights,
            })
        end,
    },

    -- LSP
    -- nvim-lspconfig: Configurations for connecting to commong LSP server implementations.
    -- lsp-zero: Functions/utils to simplify configuring NeoVim's LSP client and nvim-lspconfig.
    -- mason-lspconfig: The Mason plugin modules, simple install/management of LSP servers on the system.
    --                  The core Mason plugin is installed above but this module is specific to using
    --                  nvim-lspconfig's set of known LSP implementations to be managed.
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'VonHeikemen/lsp-zero.nvim',
            'williamboman/mason-lspconfig.nvim',
            'nvim-telescope/telescope.nvim',
            --[[
            -- Ensure nvim-java is setup prior to this
            'nvim-java/nvim-java',
            ]]--
        },
        opts = {
            setup = {
                -- Prevent automatic setup of rust-analyzer. That will be setup by rustaceanvim.
                rust_analyzer = function()
                    return true
                end,
            },
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            -- Set signs as first thing otherwise they won't take effect immediately.
            lsp_zero.set_sign_icons({
                error = '✘',
                warn = '▲',
                hint = '⚑',
                info = '»'
            })

            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(_, bufnr)
                local opts = { buffer = bufnr, remap = false }

                local telescope = require('telescope.builtin')

                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "ge", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
                vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "L", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>pt", function() telescope.lsp_dynamic_workspace_symbols() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
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
            end)

            local mason_lsp = require('mason-lspconfig')
            mason_lsp.setup({
                ensure_installed = {},
                setup_handlers = {
                    -- Disable automatic setup and configuration of rust-analyzer. That will be set up
                    -- and managed by the rustaceanvim plugin.
                    ['rust_analyzer'] = function() end,
                },
                handlers = {
                    lsp_zero.default_setup,
                },
            })
        end,
    },
}

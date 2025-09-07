-- Management of both LSP servers and auto-completion.
-- The "root" or main plugin for managing these are nvim-cmp for auto-complete
-- and nvim-lspconfig for LSP. Each have additional dependencies which
return {
    -- Rust: simplifies the configuration for an enriched LSP/DAP experience.
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false, -- The plugin itself manages being lazy
    },

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
            java.setup({
                -- Specify newer java_test than what the default has, otherwise this will
                -- constantly conflict with doing latest updates with Mason.
                -- NOTE: This seems to be required by some other means, as trying to disable
                --       will not prevent it from being auto-installed.
                java_test = {
                    enable = true,
                    version = '0.43.1',
                },
                -- Similarly, the version of spring_boot_tools specified by nvim-java is
                -- old and will conflict with latest updates from Mason, but this isn't
                -- needed by any projects I develop.
                spring_boot_tools = {
                    enable = false,
                }
            })
            local lspconfig = require('lspconfig')
            lspconfig.jdtls.setup({
            })
        end,
    },

    -- ## Below are the core plugins used for managing LSP configs, LSP servers, and auto-complete ## --

    -- Autocompletion
    -- nvim-cmp: Lua implementation of auto-completion. Uses the concept of sources
    --           or engines for providing the results.
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
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            local types = require('cmp.types')

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
                    },
                    {
                        name = 'buffer',
                        group_index = 3,
                    },
                }),
                performance = {
                    -- max_view_entries = 5,
                },
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
    -- mason-lspconfig: The Mason plugin modules, simple install/management of LSP servers on the system.
    --                  The core Mason plugin is installed above but this module is specific to using
    --                  nvim-lspconfig's set of known LSP implementations to be managed.

    -- Mason is a plugin for easily managing installations of LSP servers on the
    -- system. This is configured below to use nvim-lspconfig for providing it
    -- "registry" of LSP implementations that could be installed. Here Mason needs
    -- configured to eagerly initialize so it occurs before mason-lspconfig that
    -- is set up below as part of nvim-lspconfig. See also :h mason-lspconfig-quickstart.
    {
        'mason-org/mason.nvim',
        lazy = false,
        config = true,
    },

    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            setup = {
                -- Prevent automatic setup of rust-analyzer. That will be setup by rustaceanvim.
                rust_analyzer = function()
                    return true
                end,
            },
        },
        config = function() end,
    },

    {
        'mason-org/mason-lspconfig.nvim',

        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'neovim/nvim-lspconfig',
        },

        opts = {
            -- Disable automatic setup and configuration of rust-analyzer. That will be set up
            -- and managed by the rustaceanvim plugin.
            automatic_enable = {
                exclude = {
                    'rust_analyzer',
                }
            },
            -- Require being explicit for installing LSPs on the system.
            ensure_installed = {},
        },
    },
}

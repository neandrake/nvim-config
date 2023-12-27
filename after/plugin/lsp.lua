local lsp = require('lsp-zero')
local cmp = require('cmp')
local lspkind = require('lspkind')
local types = require('cmp.types')

lsp.preset('recommended')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
})

-- Unmap Tab
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

-- Filter for auto-complete sources to not suggest Text or Snippet
local source_entry_filter = function(entry, _ctx)
    if types.lsp.CompletionItemKind[entry:get_kind()] ~= 'Text' then return false end
    if types.lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet' then return false end
    return true
end

cmp.setup({
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
    formatting = {
        -- Change order of fields so the icon is first
        fields = { 'menu', 'abbr', 'kind' },
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',

            before = function(entry, item)
                local word = entry.get_insert_text()
                if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                    word = vim.lsp.util.parse_snippet(word)
                end

                word = str.oneline(word)
                if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                    word = word .. "~"
                end

                item.abbr = word
                return item
            end,
        }),
    },
    sources = {
        {
            name = 'nvim_lsp',
            group_index = 1,
            entry_filter = source_entry_filter,
        },
        {
            name = 'luasnip',
            group_index = 2,
            max_item_count = 5,
            entry_filter = source_entry_filter,
        },
        {
            name = 'buffer',
            group_index = 3,
            max_item_count = 5,
            entry_filter = source_entry_filter,
        },
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
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    local ts = require('telescope.builtin')

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>fS", function() ts.lsp_dynamic_workspace_symbols() end, opts)
    vim.keymap.set("n", "<leader>sd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>sa", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lR", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>rf", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

vim.diagnostic.config({
    virtual_text = true,
})

lsp.setup()

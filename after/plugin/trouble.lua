local trouble = require('trouble')

trouble.setup {
    position = 'bottom',
    height = 10,
    icons = false, -- Should be true but 'trouble' doesn't seem to pick up nvim-web-devicons being installed.
    mode = 'workspace_diagnostics',
    severity = nil, -- Use nil = ALL, otherwise vim.diagnostic.severity.ERROR | WARN | INFO | HINT.
    group = true, -- Group diagnostics by file.
    multiline = true, -- Render multi-line messages.
    auto_open = true, -- Automatically open the list when there are diagnostics.
    auto_close = true, -- Automatically close the list when there are no diagnostics.
    auto_preview = true, -- Automatically preview the location of the diagnostic.
    auto_fold = true, -- Automatically fold a file trouble list at creation.

    -- For given modes, automatically jump if there's only a single result.
    auto_jump = { 'lsp_definitions' },

    -- For given modes, include the declaration of the current symbol in the results.
    include_declaration = { 'lsp_references', 'lsp_implementations', 'lsp_definitions' },

    use_diagnostic_signs = true, -- Icons are defined for lsp via 'lspkind' plugin, use those.
}

vim.keymap.set("n", "<leader>td", trouble.toggle)

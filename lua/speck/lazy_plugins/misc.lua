-- Plugins that don't require extensive configuration

return {
    ------------------------------------
    -------------- Editor functionality
    ------------------------------------

    -- View and manage the undo tree, allows branching-like behavior with changes.
    { 'mbbill/undotree' },

    -- Abide .editorconfig settings.
    { 'gpanders/editorconfig.nvim' },

    -- Close buffers without modifying window layout.
    { 'famiu/bufdelete.nvim' },

    ------------------
    -------------- UI
    ------------------

    -- Improve VIM's default UI.
    { 'stevearc/dressing.nvim' },

    -- Notifications UI.
    { 'rcarriga/nvim-notify' },

    -- Icons for file types added to the font/glyphs. This is used by other plugins.
    -- Do first-class install here instead of as dependency, so that all plugins can
    -- find it ('trouble' had difficulties locating/identifying it being installed).
    { 'nvim-tree/nvim-web-devicons' },

    --------------------------------
    -------------- Language-context
    --------------------------------

    -- Display status of LSP server state.
    {
        'j-hui/fidget.nvim',
        -- The default config() implementation doesn't seem to properly setup fidget.
        config = function()
            require('fidget').setup()
        end,
    },

    -- Icons for LSP related context.
    { 'onsails/lspkind.nvim' },

    -- Treesitter context, to always show what scope you're in.
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },
}

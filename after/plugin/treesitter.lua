require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all"
    -- WINDOWS: When adding new languages tree-sitter will need to compile the parser.
    --          If you have llvm installed and in PATH then compilation should succeed.
    --          Otherwise run nvim from the "x64 Native Tools Command Prompt for VS 2019"
    --          which will then succeed in compiling the parsers.
    --          See: https://stackoverflow.com/a/68277910
    ensure_installed = { "help", "c", "lua", "diff", "vim",
        "rust", "java", "dockerfile", "scala", "toml", "yaml",
        "gitattributes", "gitignore", "gitcommit",
        "javascript", "typescript", "html", "css", "json", "php" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Disable highlighting on large files.
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages.
        additional_vim_regex_highlighting = false,
    },

    --[[ Enable incremental selection based on the named nodes from the grammar.
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    }, --]]

    -- Use tree-sitter for indentation when using '='. This is experimental.
    indent = {
        enable = true,
    },

}

local ts_ctx = require('treesitter-context')
ts_ctx.setup {
    enable = true,
    -- Only show a max of 5 lines of context/scope otherwise it's overwhelming
    -- and hides contextually-relevant code near the cursor.
    max_lines = 5,
    -- When max_lines is reached trim the inner scope and show the outer scope,
    -- as it's more likely the inner scope is more easily accessible through
    -- navigation.
    trim_scope = 'inner',
    -- Either 'cursor' or 'topline', specifies which to use for relative scope.
    -- Using 'cursor' causes the context to change while moving around, which
    -- is distracting.
    mode = 'topline',

    on_attach = function(buf)
        -- Disable attaching to prompts or non-file buffers.
        local buftype = vim.bo.buftype
        if buftype == 'prompt' or buftype == 'nofile' then
            return false
        end
    end,
}

vim.keymap.set("n", "gc", function() ts_ctx.go_to_context() end, { silent = true })

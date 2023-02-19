require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  -- WINDOWS: When adding new languages tree-sitter will need to compile the parser.
  --          Run nvim from the "x64 Native Tools Command Prompt for VS 2019" which
  --          will then succeed in compiling the parsers.
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

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


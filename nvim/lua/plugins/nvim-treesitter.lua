return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = { "bash", "c_sharp", "diff", "fish", "gitcommit", "git_config", "gitignore", "javascript", "json", "lua", "make", "markdown", "markdown_inline", "python", "rust", "terraform", "typescript", "vim", "vimdoc", "yaml" },

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
      enable = true,

      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true
    }
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    -- Always use treesitter for folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldnestmax = 4

    if vim.fn.filereadable(vim.fn.expand("~/Projects/tree-sitter-tea/grammar.js")) then
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.tea = {
        install_info = {
          url = "~/Projects/tree-sitter-tea",
          files = {"src/parser.c"},
          generate_requires_npm = false, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        filetype = "tea",
        used_by = { "teafile" }, -- if filetype is not the same as parser name
      }

      -- Symlink the queries
      vim.cmd('silent! !ln -s $HOME/Projects/tea/nvim-treesitter/queries/tea/ $HOME/.local/share/nvim/lazy/nvim-treesitter/queries/tea')
    end
  end
}

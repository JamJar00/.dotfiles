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
  end
}

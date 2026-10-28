return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = { "bash", "c_sharp", "diff", "fish", "gitcommit", "git_config", "gitignore", "javascript", "json", "lua", "make", "markdown", "markdown_inline", "python", "rust", "svelte", "terraform", "typescript", "vim", "vimdoc", "yaml" },

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
    require('nvim-treesitter').setup(opts)

    -- Always use treesitter for folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldnestmax = 4

    -- Need to run `:TSUpdate` then a `:TSInstall tea` if this isn't working
    if vim.fn.filereadable(vim.fn.expand("~/Projects/tree-sitter-tea/grammar.js")) then
      vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate',
        callback = function()
           require('nvim-treesitter.parsers').tea = {
             install_info = {
               -- url = 'https://github.com/zimbulang/tree-sitter-zimbu',
               -- revision = <sha>, -- commit hash for revision to check out; HEAD if missing
               path = '~/Projects/tree-sitter-tea',
               -- location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
               -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
               -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
               queries = '~/Projects/tea/nvim-treesitter/queries/tea', -- also install queries from given directory
             },
           }
         end})

      vim.filetype.add({
        extension = {
          tea = 'tea',
          teafile = 'tea'
        },
        filename = {
          ['teafile'] = 'tea'
        }
      })
    end
  end
}

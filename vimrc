" Set syntax highlighting
syntax on

" Set search highlighting and show search matches while typing
set hlsearch incsearch

" Disable esckeys to avoid slow O commands:
" https://stackoverflow.com/a/2158610/2755790
if !has('nvim')
  set noesckeys
endif

" Set nice tab behaviour
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab autoindent

" Fix dumb Mac backspace behaviour
set backspace=indent,eol,start

" Set line numbers and add the row/col at the bottom
set number relativenumber

" When autocompleting commands, show possible options (use Ctrl-N/Ctrl-P to cycle through)
set wildmenu

" Ignore big built things in search
set wildignore=target/*,node_modules/*

" Always show statusline
set laststatus=2

" Set auto reload if the file on disk changes
set autoread

" That's better
set belloff=all

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Scroll before the end of the file
set scrolloff=8

" Enable persistent undo and move swap files
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undofile
set undodir=~/.vim/undodir
set directory=~/.vim/backups//

" nvim clipboard & browser linking on WSL
if has('nvim') && system('$PATH') =~ '/mnt/c/Windows'
  set clipboard=unnamedplus
  let g:netrw_browsex_viewer="cmd.exe /C start"
endif

" Install Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
  Plug 'mhartington/oceanic-next'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-commentary'
  Plug 'itchyny/lightline.vim'
  if has('nvim')
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    Plug 'nvim-tree/nvim-web-devicons' " Optional for nvim-tree
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
  else
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'preservim/nerdtree'
    if hostname() == "FXJXWHJ0W0.local"
      Plug 'hashivim/vim-terraform'
    endif
  endif
  if hostname() == "FEATHERS" || hostname() == "Feathers"
    Plug 'leafOfTree/vim-svelte-plugin'
  endif
call plug#end()

" Enable colorscheme
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

let g:lightline = {
  \ 'colorscheme': 'PaperColor'
  \ }

" Set leader to space for ease of access
let mapleader = " "

" Shortcut to terminal
if has('nvim')
  nnoremap <leader>t :below split <bar> term<CR>a
else
  nnoremap <leader>t :below term<CR>a
endif
"
" Shortcut to NERDTree/NvimTree
if has('nvim')
  nnoremap <leader>nt :NvimTreeFindFileToggle<CR>
else
  nnoremap <leader>nt :NERDTreeFind<CR>
endif
"
" Shortcut for LeaderF ripgrep
noremap <leader>F :<C-U>LeaderfRgInteractive<CR>
noremap <leader>R :<C-U>LeaderfRgRecall<CR>
"
" Remap up/down in LeaderF
let g:Lf_CommandMap = {'<C-K>': ['<C-P>'], '<C-J>': ['<C-N>']}

" Make Y the same as D
nmap Y y$

" Make Ctrl-P show hidden files
let g:ctrlp_show_hidden = 1

" NvimTree
if has('nvim')
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1
  lua << EOF
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  git = {
    ignore = false
  }
})
EOF

  " Treesitter
  lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "bash", "diff", "fish", "gitcommit", "git_config", "gitignore", "json", "lua", "make", "markdown", "markdown_inline", "python", "rust", "terraform", "vim", "vimdoc", "yaml" },

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
}
EOF

  " LSP
  lua << EOF
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.terraformls.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF

  " nvim-cmp
  lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['terraformls'].setup {
    capabilities = capabilities
  }
EOF
endif

augroup mygroup
  autocmd!
  " Automatically remove trailing spaces
  autocmd BufWritePre * :%s/\s\+$//e
augroup end

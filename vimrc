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
  Plug 'itchyny/vim-gitbranch'
  Plug 'github/copilot.vim'
  if has('nvim')
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    Plug 'nvim-tree/nvim-web-devicons' " Optional for nvim-tree
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'neovim/nvim-lspconfig'
    Plug 'ms-jpq/coq_nvim', { 'branch': 'coq', 'do': ':COQdeps' }
    Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
    Plug 'folke/trouble.nvim'
    Plug 'mfussenegger/nvim-lint'
    Plug 'spywhere/lightline-lsp'
    Plug 'VidocqH/lsp-lens.nvim'
  else
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'preservim/nerdtree'
    if hostname() == "FXJXWHJ0W0.local"
      Plug 'hashivim/vim-terraform'
    endif
  endif
  if hostname() == "FEATHERS" || hostname() == "FLUFFLES"
    Plug 'leafOfTree/vim-svelte-plugin'
  endif
  Plug 'dstein64/vim-startuptime'
call plug#end()

" Enable colorscheme
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

" Lightline
let g:lightline = {
  \   'colorscheme': 'wombat',
  \   'component_function': {
  \      'gitbranch': 'gitbranch#name'
  \    },
  \   'component_expand': {
  \     'linter_hints': 'lightline#lsp#hints',
  \     'linter_infos': 'lightline#lsp#infos',
  \     'linter_warnings': 'lightline#lsp#warnings',
  \     'linter_errors': 'lightline#lsp#errors',
  \     'linter_ok': 'lightline#lsp#ok',
  \   },
  \   'component_type': {
  \     'linter_hints': 'right',
  \     'linter_infos': 'right',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'right',
  \   },
  \   'active': {
  \     'left': [[ 'mode', 'paste' ], ['readonly', 'filename', 'modified', 'gitbranch']],
  \     'right': [[ 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_hints', 'linter_ok' ], [ 'lineinfo' ], [ 'percent' ]]
  \   }
  \ }

let g:lightline#lsp#indicator_hints = "\uf002"
let g:lightline#lsp#indicator_infos = "\uf129"
let g:lightline#lsp#indicator_warnings = "\uf071"
let g:lightline#lsp#indicator_errors = "\uf05e"
let g:lightline#lsp#indicator_ok = "\uf00c"

" Set leader to space for ease of access
let mapleader = " "

" Shortcut to terminal
let g:term_buf_nr = -1
function! ToggleTerminal()
  " If there's no terminal or the previous one was closed create a new one, else open the old one
  if g:term_buf_nr == -1 || !bufexists(g:term_buf_nr)
    if has('nvim')
      execute "below split"
      execute "term"
    else
      execute "below term"
    endif
    let g:term_buf_nr = bufnr("$")
  else
    execute "below sbuffer " .g:term_buf_nr
  endif
endfunction

nnoremap <leader>t :call ToggleTerminal()<CR>a

" Shortcut for LeaderF ripgrep
noremap <leader>F :<C-U>LeaderfRgInteractive<CR>
noremap <leader>R :<C-U>LeaderfRgRecall<CR>

" Remap up/down in LeaderF
let g:Lf_CommandMap = {'<C-K>': ['<C-P>'], '<C-J>': ['<C-N>']}

" Shortcut to Trouble
if has('nvim')
  nnoremap <leader>T :TroubleToggle<CR>
endif

" Make Y the same as D
nmap Y y$

" Make Ctrl-P show hidden files
let g:ctrlp_show_hidden = 1

" Commentary mappings to leader
xmap <leader>c  <Plug>Commentary
nmap <leader>c  <Plug>Commentary
omap <leader>c  <Plug>Commentary
nmap <leader>cc <Plug>CommentaryLine
nmap <leader>cu <Plug>Commentary<Plug>Commentary

" Remap copilot to Ctrl-J
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

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

function open_nvim_tree()
  local api = require "nvim-tree.api"
  local path = vim.api.nvim_buf_get_name(0)
  local bufnr = vim.fn.bufnr()
  if api.tree.is_tree_buf(bufnr) then
    api.tree.close()
  else
    api.tree.find_file({
      path = path,
      open = true,
      focus = true,
      update_root = false
    })
  end
end

vim.keymap.set('n', '<leader>nt', open_nvim_tree)
EOF

  " Treesitter
  lua << EOF
require('nvim-treesitter.configs').setup {
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
}
EOF

  " LSP & Completion
  lua << EOF
-- Autostart completion (must come before require('coq'))
vim.g.coq_settings = {
  auto_start = 'shut-up'
}

local coq = require('coq')
capabilities = coq.lsp_ensure_capabilities()

-- Setup LSPs with lspconfig
local lspconfig = require('lspconfig')
lspconfig.pyright.setup(capabilities)
lspconfig.rust_analyzer.setup(capabilities)
lspconfig.terraformls.setup(capabilities)
lspconfig.csharp_ls.setup(capabilities)
if vim.fn.hostname() == "FXJXWHJ0W0.local" then
  lspconfig.ts_ls.setup(capabilities)
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Enable lens
require'lsp-lens'.setup({
  sections = {
    definition = true,
    references = true,
    implements = true,
    git_authors = false,
  }
})
EOF

  " nvim-lint
  lua <<EOF
require('lint').linters_by_ft = {
  javascript= {'eslint'},
  terraform = {'tflint', 'tfsec'},
  typescript = {'eslint'},
  typescriptreact = {'eslint'},
  sh = {'shellcheck'}
}
EOF

  autocmd BufWritePost * lua require('lint').try_lint()
  autocmd BufRead * lua require('lint').try_lint()
endif

" Automatically remove trailing spaces
function! StripTrailingWhitespace()
  let l:save_view = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save_view)
endfunction

autocmd BufWritePre * silent! call StripTrailingWhitespace()

" Automatically remove Windows new lines
function! StripWindowsLineEndings()
  let l:save_view = winsaveview()
  setlocal ff=unix
  %s/\r//g
  call winrestview(l:save_view)
endfunction

autocmd BufWritePre * silent! call StripWindowsLineEndings()

" Automatically format terraform
function! FormatTerraform()
  execute "!terraform fmt % || true"
endfunction

autocmd BufWritePost *.tf silent! call FormatTerraform()

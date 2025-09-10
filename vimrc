" Set syntax highlighting
syntax on
if has("termguicolors") " Nvim doesn't autoenable this
  set termguicolors
endif

" Set search highlighting and show search matches while typing
set hlsearch incsearch

" Disable esckeys to avoid slow O commands:
" https://stackoverflow.com/a/2158610/2755790
set noesckeys

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

" Set internal encoding of vim
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

" Highlight the cursor
set cursorline

" Enable persistent undo and move swap files
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undofile
set undodir=~/.vim/undodir
set directory=~/.vim/backups//

" Install Plug
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
  Plug 'morhetz/gruvbox'

  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-commentary'
  Plug 'itchyny/lightline.vim'
  Plug 'itchyny/vim-gitbranch'

  Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
  Plug 'preservim/nerdtree'

  if hostname() == "FXJXWHJ0W0.local"
    Plug 'hashivim/vim-terraform'
  endif
call plug#end()

" Enable colorscheme
colorscheme gruvbox

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
    execute "botright term"
    let g:term_buf_nr = bufnr("$")
  else
    execute "botright sbuffer " .g:term_buf_nr
  endif
endfunction

nnoremap <leader>t :call ToggleTerminal()<CR>a

" Make Y the same as D
nmap Y y$

" Commentary mappings to leader
xmap <leader>c  <Plug>Commentary
nmap <leader>c  <Plug>Commentary
omap <leader>c  <Plug>Commentary
nmap <leader>cc <Plug>CommentaryLine
nmap <leader>cu <Plug>Commentary<Plug>Commentary

augroup Vimrc
  autocmd!

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
    execute "silent! !terraform fmt %"
  endfunction

  autocmd BufWritePost *.tf silent! call FormatTerraform()

  " In the qf window, tab 'previews'
  autocmd FileType qf map <buffer> <tab> <CR><C-W>p
augroup END

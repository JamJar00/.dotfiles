" Set syntax highlighting
syntax on

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

" Make find command find recursively
" TODO Is this useful now we use Ctrl-P for everything...?
set path+=**

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
  Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-commentary'
  Plug 'itchyny/lightline.vim'
call plug#end()

" Coc plugins
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions
if hostname() == "FXJXWHJ0W0.local"
  let g:coc_global_extensions = ['coc-sh', 'coc-rust-analyzer']
  let g:coc_user_config = {
    \   "languageserver": {
    \     "terraform": {
    \       "command": "terraform-ls",
    \       "args": ["serve"],
    \       "filetypes": [
    \         "terraform",
    \         "tf"
    \       ],
    \       "initializationOptions": {},
    \       "settings": {}
    \     }
    \   }
    \ }
elseif hostname() == "FEATHERS" || hostname() == "Feathers"
  let g:coc_global_extensions = ['coc-json', 'coc-pyright', 'coc-svelte', 'coc-xml', 'coc-rust-analyzer']
  let g:coc_user_config = {
    \   "languageserver": {
    \     "csharp-ls": {
    \       "command": "csharp-ls",
    \       "filetypes": ["cs"],
    \       "rootPatterns": ["*.csproj", ".vim/", ".git/", ".hg/"]
    \     }
    \   }
    \ }
elseif hostname() == "FLUFFLES" || hostname() == "Fluffles"
  let g:coc_global_extensions = ['coc-rust-analyzer']
endif

" Enable colorscheme
set background=dark
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
colorscheme PaperColor

" Make NERDTree show hidden files
let NERDTreeShowHidden=1

" Make Ctrl-P show hidden files
let g:ctrlp_show_hidden = 1

" Coc
" Disables warnings on Windows install
let g:coc_disable_startup_warning = 1

" Check for updates
let g:coc_preferences_extensionUpdateCheck = "daily"

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Add Lightline support as per above comment
let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status'
  \ },
  \ }

" Set leader to space for ease of access
let mapleader = " "

" Shortcut to terminal
nnoremap <leader>t :below term<CR>

" Shortcut to NERDTree
nnoremap <leader>nt :NERDTreeToggle<CR>

" Make Y the same as D
nmap Y y$

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1):
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <CR> to confirm completion, use:
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

" Use `gn` and `gp` to navigate diagnostics
" Use `ge` to get all diagnostics of current buffer in location list.
nmap <silent> gp <Plug>(coc-diagnostic-prev)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> ge :CocDiagnostics<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')


" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Commentary mappings to leader
xmap <leader>c  <Plug>Commentary
nmap <leader>c  <Plug>Commentary
omap <leader>c  <Plug>Commentary
nmap <leader>cc <Plug>CommentaryLine
nmap <leader>cu <Plug>Commentary<Plug>Commentary

augroup mygroup
  autocmd!
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Use autocmd to force lightline update.
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup end

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
  augroup END
endif

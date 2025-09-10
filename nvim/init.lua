-- Set syntax highlighting. Nvim doesn't autoenable this
vim.opt.termguicolors = true

-- Set search highlighting and show search matches while typing
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Set nice tab behaviour
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.autoindent = true

-- Fix dumb Mac backspace behaviour
vim.opt.backspace = "indent,eol,start"

-- Set hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- When autocompleting commands, show possible options (use Ctrl-N/Ctrl-P to cycle through)
vim.opt.wildmenu = true

-- Ignore big built things in search
vim.opt.wildignore = "target/*,node_modules/*"

-- Always show statusline
vim.opt.laststatus = 2

-- Set auto reload if the file on disk changes
vim.opt.autoread = true

-- That's better
vim.opt.belloff = "all"

-- TextEdit might fail if hidden is not set.
vim.opt.hidden = true

-- Some servers have issues with backup files, see #649.
vim.opt.writebackup = false

-- Give more space for displaying messages.
vim.opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"

-- Scroll before the end of the file
vim.opt.scrolloff = 8

-- Highlight the cursor
vim.opt.cursorline = true

-- Enable persistent undo and move swap files
vim.cmd("silent! !mkdir -p " .. vim.fn.expand("~") .. "/.vim/backups > /dev/null 2>&1")
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~") .. "/.vim/undodir"
vim.opt.directory = vim.fn.expand("~") .. "/.vim/backups//"

-- nvim clipboard & browser linking on WSL
if vim.fn.has('nvim') and string.find(vim.fn.system('$PATH'), '/mnt/c/Windows') then
  vim.opt.clipboard = "unnamedplus"
  vim.g.netrw_browsex_viewer = "cmd.exe /C start"
end

vim.g.mapleader = " "

require("config.lazy")

require("config.terminal")

vim.keymap.set('n', 'Y', 'y$')

local vimrcgroup = vim.api.nvim_create_augroup('vimrc', { clear = true })

-- Strip trailing whitespace and windows newlines
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*',
  group = vimrcgroup,
  callback = function()
    local curpos = vim.api.nvim_win_get_cursor(0)

    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.cmd([[keeppatterns %s/\r\+//e]])
    vim.opt_local.ff = "unix"

    vim.api.nvim_win_set_cursor(0, curpos)
  end
})

-- Format terraform
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = '*.tf',
  group = vimrcgroup,
  command = 'silent! !terraform fmt %'
})

if vim.fn.filereadable(vim.fn.expand("~/Projects/tree-sitter-tea/grammar.js")) then
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = {'*.tea', '*.teafile', 'teafile'},
    group = vimrcgroup,
    command = 'set filetype=tea'
  })
end

-- TODO In the qf window, tab 'previews'
-- autocmd FileType qf map <buffer> <tab> <CR><C-W>p

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

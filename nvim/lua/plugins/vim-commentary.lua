return {
  'tpope/vim-commentary',
  config = function()
    vim.keymap.set('x', '<leader>c',  '<Plug>Commentary<cr>')
    vim.keymap.set('n', '<leader>c',  '<Plug>Commentary<cr>')
    vim.keymap.set('o', '<leader>c',  '<Plug>Commentary<cr>')
    vim.keymap.set('n', '<leader>cc', '<Plug>CommentaryLine<cr>')
  end
}

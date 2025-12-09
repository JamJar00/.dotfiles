return {
  'Yggdroot/LeaderF',
  lazy = false,
  init = function()
    -- Remap up/down in LeaderF
    vim.g.Lf_CommandMap = {
      ['<C-K>'] = {'<C-P>'},
      ['<C-J>'] = {'<C-N>'}
    }
  end,
  config = function()
    -- Shortcut for LeaderF ripgrep
    vim.keymap.set('n', '<leader>F', '<cmd>LeaderfRgInteractive<CR>')
    vim.keymap.set('n', '<leader>R', '<cmd>LeaderfRgRecall<CR>')

    -- FIXME fails on the the Mac due to strange pip install
    -- vim.cmd('LeaderfInstallCExtension')
  end
}

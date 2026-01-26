return {
  'github/copilot.vim',
  enabled = vim.fn.hostname() == "FXJXWHJ0W0.local" or vim.fn.hostname() == "FLUFFLES",
  init = function()
    vim.g.copilot_no_tab_map = true
  end,
  config = function()
    -- Remap copilot to Ctrl-J
    vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', { expr = true, silent = true, replace_keycodes = false })
  end
}

if vim.fn.hostname() == "FXJXWHJ0W0.local" then
  return {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      -- Remap copilot to Ctrl-J
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', { expr = true, silent = true, replace_keycodes = false })
    end
  }
else
  return nil
end

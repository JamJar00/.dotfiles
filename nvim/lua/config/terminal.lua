term_buf_nr = -1
toggle_terminal = function ()
  -- If there's no terminal or the previous one was closed create a new one, else open the old one
  if term_buf_nr == -1 or not vim.api.nvim_buf_is_loaded(term_buf_nr) then
    vim.cmd("botright term")
    term_buf_nr = vim.fn.bufnr("$")
  else
    vim.cmd("botright sbuffer " .. term_buf_nr)
  end
end

vim.keymap.set('n', '<Leader>t', toggle_terminal)

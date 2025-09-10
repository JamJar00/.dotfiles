return {
  'itchyny/lightline.vim',
  dependencies = {
    { 'itchyny/vim-gitbranch' },
    { 'spywhere/lightline-lsp' }
  } ,
  init = function()
    vim.g.lightline = {
      colorscheme = 'wombat',
      component_function = {
         gitbranch = 'gitbranch#name'
       },
      component_expand = {
        linter_hints = 'lightline#lsp#hints',
        linter_infos = 'lightline#lsp#infos',
        linter_warnings = 'lightline#lsp#warnings',
        linter_errors = 'lightline#lsp#errors',
        linter_ok = 'lightline#lsp#ok',
      },
      component_type = {
        linter_hints = 'right',
        linter_infos = 'right',
        linter_warnings = 'warning',
        linter_errors = 'error',
        linter_ok = 'right',
      },
      active = {
        left = {{ 'mode', 'paste' }, {'readonly', 'filename', 'modified', 'gitbranch'}},
        right = {{ 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_hints', 'linter_ok' }, { 'lineinfo' }, { 'percent' }}
      }
    }

    -- TODO set custom icons when I figure out how to use unicode chars
    -- let g:lightline#lsp#indicator_hints = "\uf002"
    -- let g:lightline#lsp#indicator_infos = "\uf129"
    -- let g:lightline#lsp#indicator_warnings = "\uf071"
    -- let g:lightline#lsp#indicator_errors = "\uf05e"
    -- let g:lightline#lsp#indicator_ok = "\uf00c"
    -- vim.g.lightline.lsp = {
    --   indicator_hints = 
    --   indicator_infos = 
    --   indicator_warnings = 
    --   indicator_errors = 
    --   indicator_ok = 
    -- }
  end
}

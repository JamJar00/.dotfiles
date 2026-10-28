return {
  'itchyny/lightline.vim',
  enabled = false,
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
      },
    }
  end
}

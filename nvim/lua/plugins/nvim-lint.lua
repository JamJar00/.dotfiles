return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      javascript= {'eslint'},
      terraform = {'tflint', 'tfsec'},
      typescript = {'eslint'},
      typescriptreact = {'eslint'},
      sh = {'shellcheck'}
    }

    local nvimlintgroup = vim.api.nvim_create_augroup('nvimlint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufWritePost' }, {
      pattern = '*',
      group = nvimlintgroup,
      callback = function()
          lint.try_lint(nul, { ignore_errors = true })
      end
    })
  end
}

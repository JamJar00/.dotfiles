return {
  "nvim-neotest/neotest",
  enabled = os.getenv("GITPOD_REPO_ROOT") ~= "",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    "nvim-neotest/neotest-python",
  },
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      adapters = {
        require("neotest-python")
      },
    })

    vim.keymap.set('n', '<leader>n', function() neotest.run.run() end)
    vim.keymap.set('n', '<leader>N', function() neotest.run.run(vim.fn.expand("%")) end)

    vim.api.nvim_create_user_command('NeotestSummary', function(opts) neotest.summary.toggle() end, {})
  end
}

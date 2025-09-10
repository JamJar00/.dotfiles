return {
  "neovim/nvim-lspconfig",
  version = "*",
  lazy = false,
  dependencies = {
    { "ms-jpq/coq_nvim", branch = "coq" },
    { "ms-jpq/coq.artifacts", branch = "artifacts" },
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = 'shut-up'
    }
  end,
  config = function()
    local coq = require('coq')
    capabilities = coq.lsp_ensure_capabilities()

    -- Setup LSPs with lspconfig
    local lspconfig = require('lspconfig')
    lspconfig.pyright.setup(capabilities)
    lspconfig.rust_analyzer.setup(capabilities)
    lspconfig.terraformls.setup(capabilities)
    -- lspconfig.csharp_ls.setup(capabilities)
    -- if vim.fn.hostname() == "FXJXWHJ0W0.local" then
    --   lspconfig.ts_ls.setup(capabilities)
    -- end

    if vim.fn.filereadable(vim.fn.expand("~/Projects/tree-sitter-tea/grammar.js")) then
      -- vim.lsp.config['tea-ls'] = {
      --   filetypes = { 'tea', 'teafile' },
      -- }

      vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
        pattern = {'*.tea', '*.teafile', 'teafile'},
        callback = function(ev)
          print("Starting tea-ls")
          vim.lsp.start {
              name = "Tea LS",
              cmd = {vim.fn.expand("~/Projects/tea-ls/target/debug/tea-ls")},
              capabilities = vim.lsp.protocol.make_client_capabilities(),
          }
        end
      })
    end

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('VimrcLspConfig', {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>=', function()
          vim.lsp.buf.format { async = true }
        end, opts)

        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      end,
    })
  end
}

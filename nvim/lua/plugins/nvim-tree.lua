return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    git = {
      ignore = false
    }
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)

     function open_nvim_tree()
      local ani = require("nvim-tree.api")
      local path = vim.api.nvim_buf_get_name(0)
      local bufnr = vim.fn.bufnr()
      if api.tree.is_tree_buf(bufnr) then
        api.tree.close()
      else
        api.tree.find_file({
          path = path,
          open = true,
          focus = true,
          update_root = false
        })
      end
    end

    vim.keymap.set('n', '<leader>nt', open_nvim_tree)
  end
}

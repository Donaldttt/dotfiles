
if HasPlug('nvim-tree.lua') then

  local api = require('nvim-tree.api')
  local M = {}

  function M.print_node_path()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end

  function M.on_attach(bufnr)
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    -- vim.keymap.set('n', 'u',     api.node.navigate.parent,              opts('Parent Directory'))
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
    vim.keymap.set('n', 'dd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'rn', api.fs.rename_basename, opts('Rename: Basename'))
    vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
    vim.keymap.set('n', 'cd', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', 'X', api.tree.collapse_all, opts('Collapse'))
    vim.keymap.set('n', 'O', api.tree.expand_all, opts('Expand All'))
    vim.keymap.set('n', 'p', M.print_node_path, opts('Print node path'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  end

  vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>',
    { desc = 'Toggle nvim-tree', noremap = true, silent = true, nowait = true })

  require("nvim-tree").setup({
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    sort_by = "case_sensitive",
    on_attach = M.on_attach,
    view = {
      width = 30,
    },
    filters = {
      dotfiles = false,
    },
    git = {
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = true,
        resize_window = true,
        window_picker = {
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", "vista" },
              buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
  })

  vim.fn['theme#addTransGroup']({'NvimTreeWinSeparator', 'NvimTreeNormal', 'NvimTreeNormalNC'})

end


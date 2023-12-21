
if HasPlug('project.nvim') then
  require("project_nvim").setup {
    detection_methods = { "lsp", "pattern" },
    patterns = { ".git" },

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {},
    -- Show hidden files in telescope
    show_hidden = false,
    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = true,
    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.g.vim_dir .. "/.vimproject/"
  }

  -- if HasPlug('telescope.nvim') then
  --   require('telescope').load_extension('projects')
  --   vim.keymap.set('n', '<leader>fp', require'telescope'.extensions.projects.projects,
  --     { desc = "Lists projects" })
  -- end

end

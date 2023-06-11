if HasPlug('nvim-treesitter') then
  require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "bash", "lua", "python", "vim" },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true
    }
  }
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
end


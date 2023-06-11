
if HasPlug('vim-illuminate') then
  require'nvim-treesitter.configs'.setup {
    matchup = {
      enable = true,
      disable = { },
    },
  }
end

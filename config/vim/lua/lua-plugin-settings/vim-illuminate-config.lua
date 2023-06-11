if HasPlug('vim-illuminate') then
  local illuminate = require('illuminate')
  illuminate.configure({
    providers = {
      'lsp',
      'treesitter',
      'regex',
    },
    delay = 0,
    filetype_overrides = {},
    filetypes_denylist = {
      'dirvish',
      'fugitive',
      'NvimTree',
      'help',
      'vista',
      'aerial',
    },
    filetypes_allowlist = {},
    modes_denylist = {},
    modes_allowlist = {},
    providers_regex_syntax_denylist = {},
    providers_regex_syntax_allowlist = {},
    under_cursor = true,
    large_file_cutoff = nil,
    large_file_overrides = nil,
    min_count_to_highlight = 1,
  })
end


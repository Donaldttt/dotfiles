
if not Animation_enable then
  if HasPlug('indent-blankline.nvim') then
    -- Example config in Lua
    require("indent_blankline").setup {
      show_current_context = true,
      use_treesitter = true,
      filetype_exclude = { "lspinfo", "packer", "checkhealth",
        "help", "man", "", "startify", }
      -- use_treesitter = true,
    }
  end
end


if not Animation_enable then
  if HasPlug('indent-blankline.nvim') then
    -- Example config in Lua
    require("ibl").setup {
      exclude = {
        buftypes = {"lspinfo", "packer", "checkhealth",
        "help", "man", "", "startify"},
      }
    }
  end
end


if HasPlug('github-nvim-theme') then
  -- Example config in Lua
  require("github-theme").setup({
    -- Overwrite the highlight groups
    overrides = function(c)
      return {
        NormalFloat = { link = 'Pmenu' },
      }
    end
  })
end


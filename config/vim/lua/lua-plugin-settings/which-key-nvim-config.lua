
if HasPlug('which-key.nvim') then
  Which_key = require("which-key")
  Which_key.setup({
    triggers_blacklist = {
      i = { "j", "k" },
      v = { "j", "k" },
      c = { "w" },
    },
  })
end

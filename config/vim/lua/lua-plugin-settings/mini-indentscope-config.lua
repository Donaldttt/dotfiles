
if HasPlug('mini.indentscope') then
  MiniIndentscope = require('mini.indentscope')
  MiniIndentscope.setup({
    symbol = '│',
    -- draw = {
    --      animation = MiniIndentscope.gen_animation.linear({
    --          easing = 'out',
    --          duration = 150,
    --          unit = 'total'
    --      })
    -- },
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
      "NvimTree", "vista", "startify", "toggleterm" },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end

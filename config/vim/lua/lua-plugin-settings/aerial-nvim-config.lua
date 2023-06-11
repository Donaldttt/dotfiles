
if HasPlug('github-nvim-theme') then
  require('aerial').setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    layout = {
      width = 50,
      default_direction = "right",
      preserve_equality = true,
    },
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end
  })
  -- You probably also want to set a keymap to toggle aerial
  vim.keymap.set('n', '<leader>v', '<cmd>AerialToggle!<CR>')
end

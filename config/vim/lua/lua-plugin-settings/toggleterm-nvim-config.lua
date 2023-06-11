
if HasPlug('toggleterm.nvim') then
  require("toggleterm").setup({

    open_mapping = [[<c-\>]],
    direction = 'float',
    float_opts = {
      border = 'rounded',
      width = function(term) return math.floor(vim.o.columns * 0.5) end,
      height = function(term) return math.floor(vim.o.lines * 0.5) end,
      winblend = 20,
      row = vim.o.lines * 0.5 - 3,
      col = vim.o.columns * 0.5,
    },
  })
  function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end

  -- vim.cmd('autocmd TermOpen term://* lua set_terminal_keymaps()')
  vim.cmd('autocmd FileType toggleterm lua set_terminal_keymaps()')

  local Terminal = require('toggleterm.terminal').Terminal

  local ipythonId = 779
  local ipython  = Terminal:new({
  size = function(term)
    if term.direction == "horizontal" then
      return 15 elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
    cmd = "ipython",
    hidden = true,
    direction = "vertical",
    close_on_exit = false,
    auto_scroll = true,
    id = ipythonId,
  })

  function _ipython_toggle()
    local currentWindow=vim.fn.winnr()
    ipython:toggle(vim.o.columns * 0.5, 'vertical')
    vim.cmd(currentWindow .. "wincmd w")
  end

  vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>lua _ipython_toggle()<CR>", { noremap = true, silent = true })

  vim.api.nvim_set_keymap("n", "<leader>tl", string.format("<cmd>ToggleTermSendCurrentLine %d<CR>", ipythonId),
    { noremap = true, silent = true })
  -- sends all the (whole) lines in your visual selection
  vim.api.nvim_set_keymap("v", "<leader>tl", string.format(":ToggleTermSendVisualLines %d<CR>", ipythonId),
    { noremap = true, silent = true })
  -- sends only the visually selected text (this can be a block of text
  vim.api.nvim_set_keymap("x", "<leader>tl", string.format(":ToggleTermSendVisualSelection %d<CR>", ipythonId),
    { noremap = true, silent = true })

end

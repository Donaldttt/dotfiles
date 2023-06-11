
if HasPlug('lualine.nvim') then

  -- custom lualine plugin show coc lsp status
  local function cocstatus()
    local loading = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local step = #loading
    local ok, result = pcall(vim.fn.CocAction, 'services')
    if not ok then
      return
    end
    local ft = vim.bo.filetype
    local state, id
    for _, entry in ipairs(result) do
      if entry['languageIds'][1] == ft then
        state = entry['state']
        id = entry['id']
        break
      end
    end
    local speed = 1600
    local loadidx = (vim.loop.now() % speed)
    local msg = id
    if state == "starting" then
      return msg .. " " .. loading[math.floor(loadidx / (step * (speed / 100))) + 1]
    elseif state == "running" then
      return msg
    end
    return ''
  end

  local _section_x = {}
  local _section_y = {}
  -- if HasPlug('coc.nvim') then table.insert(_section_x, cocstatus) end
  table.insert(_section_x, cocstatus)
  local disabled_filetypes_data = {}
  if Vim_version_minor < 7 then
    -- globalstatus only work for nvim >= 0.7
    disabled_filetypes_data = {     -- Filetypes to disable lualine for.
      statusline = {},              -- only ignores the ft for statusline.
      winbar = {},                  -- only ignores the ft for winbar.
      'NvimTree',
      'vista',
    }
  end

  local opt = {
    options = {
      icons_enabled = Show_icon,
      theme = 'auto',       -- lualine theme
      -- component_separators = { left = '', right = ''},
      -- section_separators = { left = '', right = ''},
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_divide_middle = false,
      globalstatus = true,
      disabled_filetypes = disabled_filetypes_data,
      refresh = { statusline = 200 }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {},
      lualine_c = {
        {
          'buffers',
          mode = 2,
          max_length = function()
            return vim.o.columns - 30
          end,
          filetype_names = {
            TelescopePrompt = 'Telescope',
            dashboard = 'Dashboard',
            packer = 'Packer',
            fzf = 'FZF',
            alpha = 'Alpha',
            NvimTree = 'NvimTree',
            vista = 'Vista',
          },
          symbols = {
            alternate_file = '',
          },
        }
      },
      -- lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_x = _section_x,
      lualine_y = _section_y,
      lualine_z = { 'location' }
    },
  }

  require('lualine').setup(opt)

  vim.fn['theme#addTransGroup']({'lualine_c_inactive', 'lualine_c_normal'})

  vim.o.fillchars ='eob: ,vert:│,stl: ,stlnc: ,'

  for i = 1, 9 do
    -- :nnoremap <silent> <Leader>1 :LualineBuffersJump 1<CR>
    vim.api.nvim_set_keymap('n', '<Leader>' .. i, ':LualineBuffersJump ' .. i .. '<CR>',
      { noremap = true, silent = true, nowait = true })
  end
  for i = 10, 20 do
    -- :nnoremap <silent> <Leader>1 :LualineBuffersJump 1<CR>
    vim.api.nvim_set_keymap('n', '<Space>' .. i, ':LualineBuffersJump ' .. i .. '<CR>',
      { noremap = true, silent = true, nowait = true })
  end
end


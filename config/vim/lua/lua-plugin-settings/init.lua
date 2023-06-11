-------------------OPTIONS-----------------------

-- enable animation of command like "<C-u>" and "<C-d>", or cursor
-- jump animation. (Performence will be effected)
Animation_enable = vim.g.animation_enable
High_performence = vim.g.high_performence

-- false basicly enable plugins like noice, nvim-notify etc.
Classic_vim_ui = vim.g.classic_vim_ui


------------------VIM OPTIONS-----------------------

vim.o.signcolumn = 'auto:2'

------------------UTILITIES----------------------

Vim_version = vim.version()
Vim_version_minor = Vim_version['minor']

function HasPlug(name)
    return vim.fn['utils#hasplug'](name)
end

-- use to print object
function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

Which_key = nil
function Wk_register(opt)
  if Which_key == nil then
    return
  end
  Which_key.register(opt)
end

Show_icon = false
if HasPlug('nvim-web-devicons') then
  Show_icon = true
end


----------------CONFIGURATION--------------------

local plugin_setting_paths = vim.fn.split(vim.fn.glob(vim.g.dotvimdir
  .. "/lua/lua-plugin-settings/*config.lua"), '\n')
local plugin_settings = vim.fn.map(plugin_setting_paths, 'fnamemodify(v:val, ":t:r")')

for _idx, name in pairs(plugin_settings) do
  require('lua-plugin-settings.'..name)
end


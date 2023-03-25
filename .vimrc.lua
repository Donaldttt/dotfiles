-------------------------------------------------
-------------------OPTIONS-----------------------
-------------------------------------------------

-- enable animation of command like "<C-u>" and "<C-d>", or cursor
-- jump animation. (Performence will be effected)
local animation_enable = vim.g.animation_enable
local high_performence = vim.g.high_performence
local debug_mode = vim.g.debug_mode

-- false basicly enable plugins like noice, nvim-notify etc.
local classic_vim_ui = vim.g.classic_vim_ui

-------------------------------------------------
------------------UTILITIES----------------------
-------------------------------------------------

local vim = vim
function HasPlug(name)
    return vim.fn.HasPlug(name)
end

-- use as a wrapper function to set keymap that call a function with
-- parameters
local _wrap = function(func, ...)
  local args = { ... }
  return function()
    func(unpack(args))
  end
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

local wk = nil
local function wk_register(opt)
  if wk == nil then
    return
  end
  wk.register(opt)
end

-------------------------------------------------
----------------CONFIGURATION--------------------
-------------------------------------------------

local vim_version = vim.version()

local vim_version_minor = vim_version['minor']

local show_icon = false
if HasPlug('nvim-web-devicons') then
  show_icon = true
end

local function nvim_noice_config()
  if classic_vim_ui
      or not HasPlug('noice.nvim')
      or not HasPlug('nvim-notify')
      or not HasPlug('nui.nvim') then
    return
  end

  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true,               -- use a classic bottom cmdline for search
      -- command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true,       -- long messages will be sent to a split
      inc_rename = false,                 -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,             -- add a border to hover docs and signature help
    },
    cmdline = {
      enabled = true,       -- enables the Noice cmdline UI
      -- view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {},            -- global options for the cmdline. See section on views
      format = {
        -- cmdline = false,
        search_down = false,
        search_up = false,
        -- filter = false,
        -- help = false,
        -- input = {},  -- Used by input()
        -- lua = false, -- to disable a format, set to `false`
      },
    },
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,                  -- enables the Noice messages UI
      view = "notify",                 -- default view for messages
      view_error = "notify",           -- view for errors
      view_warn = "notify",            -- view for warnings
      view_history = "messages",       -- view for :messages
      view_search = false,             -- view for search count messages. Set to `false` to disable
    },
  })
end

local function nvim_scrollbar_config()
  if classic_vim_ui or
      not HasPlug('nvim-scrollbar') then
    return
  end
  require("scrollbar").setup({
    excluded_filetypes = {
      "prompt",
      "TelescopePrompt",
      "noice",
      "startify",
      "vista",
    },
  })
end

local function toggleterm_config()
  if not HasPlug('toggleterm.nvim') then
    return
  end
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

  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
end

local function vim_illuminate_config()
  if not HasPlug('vim-illuminate') then
    return
  end
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

local function which_key_config()
  if not HasPlug('which-key.nvim') then
    return
  end
  wk = require("which-key")
  wk.setup({
    triggers_blacklist = {
      i = { "j", "k" },
      v = { "j", "k" },
      c = { "w" },
    },
  })
end
vim.g.hhx = ''
local function telescope_config()
  if not HasPlug('telescope.nvim') then
    return
  end
  local actions = require("telescope.actions")
  local action_state = require "telescope.actions.state"
  if HasPlug('telescope-fzf-native.nvim') then
    require('telescope').setup {
      pickers = {
        colorscheme = {
          enable_preview = true,
          mappings = {
            i = {
                  ["<CR>"] = function(bufnr)
                local selection = action_state.get_selected_entry()
                actions.select_default()
                vim.fn.Theme_persistent(selection.value)
              end,
            },
          },
        }
      },
      extensions = {
        fzf = {
          fuzzy = true,         -- false will only do exact matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",         -- or "ignore_case" or "respect_case"
        }
      }
    }
    require('telescope').load_extension('fzf')
  end

  local builtin = require('telescope.builtin')

  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Search files inside cwd" })
  -- need to install ripgrep
  vim.keymap.set('n', '<leader>fr', builtin.live_grep, { desc = "Regex search inside files" })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Search buffers" })
  vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = "Search colorscheme" })
  wk_register({ ["<leader>f"] = { name = "+Telescope" } })

  vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    command = "setlocal wrap number"
  })
end

local function github_theme_config()
  if not HasPlug('github-nvim-theme') then
    return
  end
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

local function animate_config()
  if not animation_enable then
    return
  end

  if HasPlug('mini.animate') then
    local animate = require('mini.animate')
    animate.setup({
      cursor = {
        -- Whether to enable this animation
        enable = true,
        -- Timing of animation (how steps will progress in time)
        -- timing = --<function: implements linear total 250ms animation duration>,
      },
      scroll = {
        -- Whether to enable this animation
        enable = true,
        -- Timing of animation (how steps will progress in time)
        timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
      },
      open = {
        -- Whether to enable this animation
        enable = false,
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
        "NvimTree", "vista", "toggleterm", "noice" },
      callback = function()
        vim.b.minianimate_disable = true
      end,
    })
  end

  -- if HasPlug('neoscroll.nvim') then
  --     require('neoscroll').setup({
  --     -- Set any options as needed
  --         mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
  --                 },
  --     })

  --     local t = {}
  --     -- Syntax: t[keys] = {function, {function arguments}}
  --     t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '150'}}
  --     t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '150'}}
  --     t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '200'}}
  --     t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '200'}}
  --     -- t['zb']    = {'zb', {'250'}}

  --     require('neoscroll.config').set_mappings(t)
  -- end
end

local function indentline_config()
  if not animation_enable then
    if HasPlug('indent-blankline.nvim') then
      -- Example config in Lua
      require("indent_blankline").setup {
        show_current_context = true,
        filetype_exclude = { "lspinfo", "packer", "checkhealth",
          "help", "man", "", "startify", }
        -- use_treesitter = true,
      }
    end
  else
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
  end
end

local function transparent_config()
  if not HasPlug('nvim-transparent') then
    return
  end
  require("transparent").setup({
    extra_groups = {   -- table/string: additional groups that should be cleared
      -- In particular, when you set it to 'all', that means all available groups
      "NvimTreeNormal",
      "VertSplit",
    },
    exclude_groups = {},   -- table: groups you don't want to clear
  })
end

local function lualine_config()
  if not HasPlug('lualine.nvim') then
    return
  end

  vim.api.nvim_set_hl(0, 'CocstatusSucceed', { fg = "#e32be0" })
  vim.api.nvim_set_hl(0, 'CocstatusLoading', { fg = "#35f0e9" })
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
    local msg = "lsp:" .. id
    if state == "starting" then
      return msg .. " %#CocstatusLoading#" .. loading[math.floor(loadidx / (step * (speed / 100))) + 1]
    end
    return msg .. " %#CocstatusSucceed#✔"
  end

  local function debugstats()
    local t = vim.fn.Debugstats()
    return "ft:" .. t['filetype'] .. " bt:" .. t['buftype'] .. " wid:" .. t['winid']
  end

  local _section_x = {}
  local _section_y = { 'encoding' }
  if HasPlug('coc.nvim') then table.insert(_section_x, cocstatus) end
  if debug_mode then _section_y = { debugstats } end

  local disabled_filetypes_data = {}
  if vim_version_minor < 7 then
    -- globalstatus only work for nvim >= 0.7
    disabled_filetypes_data = {
                                    -- Filetypes to disable lualine for.
      statusline = {},              -- only ignores the ft for statusline.
      winbar = {},                  -- only ignores the ft for winbar.
      'NvimTree',
      'vista',
    }
  end

  local opt = {
    options = {
      icons_enabled = show_icon,
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
          filetype_names = {
            TelescopePrompt = 'Telescope',
            dashboard = 'Dashboard',
            packer = 'Packer',
            fzf = 'FZF',
            alpha = 'Alpha',
            NvimTree = '',
            vista = '',
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

local function nvim_treesitter_config()
  if not HasPlug('nvim-treesitter') then
    return
  end
  require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "bash", "lua", "python", "vim" },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end

local function nvim_tree_config()
  if not HasPlug('nvim-tree.lua') then
    return
  end
  -- disable netrw at the very start of your init.lua (strongly advised)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local api = require('nvim-tree.api')
  local M = {}

  function M.print_node_path()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end

  function M.on_attach(bufnr)
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    -- vim.keymap.set('n', 'u',     api.node.navigate.parent,              opts('Parent Directory'))
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
    vim.keymap.set('n', 'dd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'rn', api.fs.rename_basename, opts('Rename: Basename'))
    vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
    vim.keymap.set('n', 'cd', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', 'X', api.tree.collapse_all, opts('Collapse'))
    vim.keymap.set('n', 'O', api.tree.expand_all, opts('Expand All'))
    vim.keymap.set('n', 'p', M.print_node_path, opts('Print node path'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  end

  vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>',
    { desc = 'Toggle nvim-tree', noremap = true, silent = true, nowait = true })
  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    on_attach = M.on_attach,
    view = {
      width = 30,
    },
    filters = {
      dotfiles = false,
    },
    git = {
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = true,
        resize_window = true,
        window_picker = {
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", "vista" },
              buftype = { "nofile", "terminal", "help" },
          },
        },
      },
    },
  })

end

if vim_version_minor >= 5 then
  vim_illuminate_config()
  transparent_config()
  github_theme_config()
  indentline_config()
  which_key_config()
  animate_config()
  nvim_scrollbar_config()
  lualine_config()
end
if vim_version_minor >= 7 then
  nvim_treesitter_config()
  telescope_config()
  toggleterm_config()
end
if vim_version_minor >= 8 then
  nvim_tree_config()
  nvim_noice_config()
end

local function late_loading()
end

-- late loading
vim.api.nvim_create_autocmd({ "VimEnter" },
  { pattern = { "*" }, callback = late_loading, })

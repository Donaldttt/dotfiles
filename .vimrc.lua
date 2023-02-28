local vim_version = vim.version()
local vim_version_minor = vim_version['minor']

-- debug
-- print(vim.inspect(version))
--
local function vim_illuminate_config()
    require('illuminate').configure({
        providers = {
            'lsp',
            'treesitter',
            'regex',
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
            'dirvish',
            'fugitive',
            'NvimTree',
            'help',
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

local function telescope_config()
    if vim.fn.HasPlug('telescope-fzf-native.nvim') then
        require('telescope').setup {
            extensions = {
                fzf = {
                  fuzzy = true,  -- false will only do exact matching
                  override_generic_sorter = true,
                  override_file_sorter = true,
                  case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                }
            }
        }
        require('telescope').load_extension('fzf')
    end
    
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader><leader>f', builtin.find_files, {})
    -- need to install ripgrep
    vim.keymap.set('n', '<leader><leader>r', builtin.live_grep, {})
    -- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.api.nvim_create_autocmd(
        "User", 
        {
            pattern = "TelescopePreviewerLoaded",
            command = "setlocal wrap number"
        }
    )
end

local function github_theme_config()
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

local function color_picker_nvim_config()
    -- config for ziontee113/color-picker.nvim
    require("color-picker").setup({
        ["keymap"] = { -- mapping example:
            ["U"] = "<Plug>ColorPickerSlider5Decrease",
            ["O"] = "<Plug>ColorPickerSlider5Increase",
        },
    })
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "cp", "<cmd>PickColor<cr>", opts)
    -- vim.keymap.set("i", "<C-u>c", "<cmd>PickColorInsert<cr>", opts)
end

local function indent_blankline_config()
    -- Example config in Lua
    require("indent_blankline").setup {
        show_current_context = true,
        filetype_exclude =   { "lspinfo", "packer", "checkhealth", "help", "man", "", "startify",}
        -- use_treesitter = true,
    }

end

local function transparent_config()
    require("transparent").setup({
      enable = true, -- boolean: enable transparent
      extra_groups = { -- table/string: additional groups that should be cleared
          -- In particular, when you set it to 'all', that means all available groups
          "NvimTreeNormal",
          "VertSplit",
      },
      exclude = {}, -- table: groups you don't want to clear
    })
end

local function lualine_config()
    for i=1,9 do
        vim.api.nvim_set_keymap('n', '<Leader>'..i, ':LualineBuffersJump '..i..'<CR>', { noremap = true, silent = true, nowait = true })
        -- :nnoremap <silent> <Leader>1 :LualineBuffersJump 1<CR>
    end
    for i=10,20 do
        vim.api.nvim_set_keymap('n', '<Space>'..i, ':LualineBuffersJump '..i..'<CR>', { noremap = true, silent = true, nowait = true })
        -- :nnoremap <silent> <Leader>1 :LualineBuffersJump 1<CR>
    end

    local disabled_filetypes_data = {}
    if vim_version_minor < 7 then
        -- globalstatus only work for nvim >= 0.7
        disabled_filetypes_data = {     -- Filetypes to disable lualine for.
          statusline = {},       -- only ignores the ft for statusline.
          winbar = {},           -- only ignores the ft for winbar.
          'NvimTree'
        }
    end
    require('lualine').setup {
        options = {
            theme = 'auto', -- lualine theme
            -- theme = 'ayu', -- lualine theme
            always_divide_middle = false,  -- When set to true, left sections i.e. 'a','b' and 'c'
                                           -- can't take over the entire statusline even
                                           -- if neither of 'x', 'y' or 'z' are present.
            globalstatus = true,
            disabled_filetypes = disabled_filetypes_data,
        },
        sections = {
            lualine_a = {'mode'},
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
                    NvimTree = ''
                },
                max_length = vim.o.columns - 27,   -- Maximum width of buffers component,
                                                      -- it can also be a function that returns
                                                      -- the value of `max_length` dynamically.
                symbols = {
                    modified = ' ●',      -- Text to show when the buffer is modified
                    alternate_file = '', -- Text to show to identify the alternate file
                    directory =  '',     -- Text to show when the buffer is a directory
                },
                }
            },
            -- lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {'encoding', 'location'}
        },
    }
end

local function nvim_treesitter_config()
    require('nvim-treesitter.configs').setup {
        -- ensure_installed = { "c", "bash", "lua" },
        sync_install = false,
        auto_install = true,
        -- ignore_install = { "javascript" },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end

local function nvim_tree_config()
    -- disable netrw at the very start of your init.lua (strongly advised)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    -- setup with some options
    require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
            width = 30,
            mappings = {
                list = {
                    { key = "C-[", action = "dir_up" },
                    { key = "C-]", action = "cd" },
                    { key = "<C-k>", action = "toggle_file_info" },
                },
            },
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = false,
        },
        actions = {
            open_file = {
                quit_on_open = true,
                resize_window = true,
                window_picker = {
                    exclude = {
                        filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                        buftype = { "nofile", "terminal", "help" },
                    },
                },
            },
        },
    })

    vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
end

if vim_version_minor >= 5 then
    vim_illuminate_config()
    transparent_config()
    lualine_config()
    github_theme_config()
    indent_blankline_config()
end
if vim_version_minor >= 7 then
    nvim_treesitter_config()
    telescope_config()
    -- color_picker_nvim_config()
    -- lsp_zero_config()
end
if vim_version_minor >= 8 then
    nvim_tree_config()
end


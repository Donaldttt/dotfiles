
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

require('lualine').setup {
    sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = { 
            {
            'buffers',
            mode = 4,
            }
        },
        -- lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_x = {'encoding'},
        lualine_y = {},
        lualine_z = {'location'}
    },
    -- tabline = {
    --     lualine_a = {
    --         {
    --         'buffers',
    --         mode = 4,
    --         }
    --     },
    --     lualine_b = {},
    --     lualine_c = {},
    --     lualine_x = {},
    --     lualine_y = {},
    --     lualine_z = {'tabs'}
    -- },
    -- winbar = {
    --     lualine_a = {},
    --     lualine_b = {},
    --     lualine_c = {'filename'},
    --     lualine_x = {},
    --     lualine_y = {},
    --     lualine_z = {}
    -- },
}

-- nvim-tree configuration
--

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
})

--
-- nvim-tree configuration end

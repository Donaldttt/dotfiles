if HasPlug('telescope.nvim') then
  local actions = require("telescope.actions")
  local action_state = require "telescope.actions.state"
  local telescope = require("telescope")
  local builtin = require('telescope.builtin')
  local telescopeConfig = require("telescope.config")
  local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
  table.insert(vimgrep_arguments, "--hidden")

  require('telescope.pickers.layout_strategies').horizontal_merged = function(picker, max_columns, max_lines,
                                                                              layout_config)
    local layout = require('telescope.pickers.layout_strategies').horizontal(picker, max_columns, max_lines,
    layout_config)
    layout.prompt.title = ''
    layout.results.title = ''
    -- layout.prompt.borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
    return layout
  end
  telescope.setup {
    pickers = {
      colorscheme = {
        enable_preview = true,
        mappings = {
          i = {
            ["<CR>"] = function(bufnr)
              local selection = action_state.get_selected_entry()
              actions.select_default()
              local bg = vim.o.background
              vim.fn['theme#setColor'](bg, selection.value)
            end,
          },
        },
      }
    },
    defaults = {
      hidden = true,
      vimgrep_arguments = vimgrep_arguments,
      file_ignore_patterns = {"^node_modules/", "^.git/"},
      layout_config = {
        -- prompt_position = "top",
      },
      layout_strategy = "horizontal_merged",
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
  if HasPlug('telescope-fzf-native.nvim') then
    telescope.load_extension('fzf')
  end

  vim.fn['theme#addCleanBg']({ 'TelescopeNormal', 'TelescopeBorder', 'TelescopePromptNormal',
    'TelescopePromptBorder', 'TelescopePromptPrefix', 'TelescopeResultsTitle', 'TelescopePreviewTitle',
    'TelescopePromptTitle', 'TelescopePromptCounter' })

  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Search files inside cwd" })
  -- need to install ripgrep
  vim.keymap.set('n', '<leader>fr', builtin.live_grep, { desc = "Regex search inside files" })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Search buffers" })
  vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = "Search colorscheme" })
  vim.keymap.set('n', '<leader>fs', builtin.treesitter, { desc = "Lists Function names, variables, from Treesitter!" })
  vim.keymap.set('n', '<leader>fh', builtin.highlights, { desc = "Lists highlight" })
  vim.keymap.set('n', '<leader>fd', builtin.help_tags, { desc = "Lists highlight" })

  Wk_register({ ["<leader>f"] = { name = "+Telescope" } })

  vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    command = "setlocal wrap number"
  })

  -- options picker
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values

  function _G.telescope_option_picker()
    local opts = require("telescope.themes").get_dropdown {}
    pickers.new(opts, {
      prompt_title = "Options",
      finder = finders.new_table {
        results = vim.fn['options#getAll'](),
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry[2],
            ordinal = entry[2],
          }
        end
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.fn['options#toggle'](selection['value'][1])
        end)
        return true
      end,
    }):find()
  end

  vim.keymap.set('n', '<leader>fo', telescope_option_picker, { desc = "Lists Function names, variables, from Treesitter!" })
end

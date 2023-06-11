if not Classic_vim_ui
    and HasPlug('noice.nvim')
    and HasPlug('nvim-notify')
    and HasPlug('nui.nvim') then

  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,         -- use a classic bottom cmdline for search
      -- command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {},      -- global options for the cmdline. See section on views
      format = {
        -- cmdline = false,
        search_down = false,
        search_up = false,
        help = { pattern = '', icon = '' },
      },
    },
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true,            -- enables the Noice messages UI
      view = "notify",           -- default view for messages
      view_error = "notify",     -- view for errors
      view_warn = "notify",      -- view for warnings
      view_history = "messages", -- view for :messages
      view_search = false,       -- view for search count messages. Set to `false` to disable
    },
  })

  vim.fn['theme#addTransGroup']({'NotifyERRORBody', 'NotifyWARNBody', 'NotifyINFOBody', 'NotifyDEBUGBody', 'NotifyTRACEBody',
        'NotifyERRORBorder', 'NotifyWARNBorder', 'NotifyINFOBorder', 'NotifyDEBUGBorder', 'NotifyTRACEBorder'})
end

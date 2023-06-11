
if utils#hasplug('minimap.vim')
    nnoremap <silent> mm :MinimapToggle<CR>
    let g:minimap_highlight_search = 1
    let g:minimap_git_colors = 1
    let g:minimap_enable_highlight_colorgroup = 1
    let g:minimap_block_filetypes = ['fugitive', 'nvim-tree', 'tagbar', 'fzf', 'telescope', 'NvimTree', 'nerdtree']
    let g:minimap_block_buftypes = ['help', 'nerdtree', 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt', 'NvimTree']
    let g:minimap_close_filetypes = ['startify', 'netrw', 'vim-plug', 'NvimTree']
    let g:minimap_range_color = 'Visual'
    let g:minimap_cursor_color = 'Cursor'
endif


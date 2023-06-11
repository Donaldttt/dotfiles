
if utils#hasplug('vim-gitgutter')
    call theme#addCleanBg(['GitGutterAdd', 'GitGutterChange', 'GitGutterDelete', 'GitGutterChangeDelete'])
    nnoremap <leader>gt :GitGutterBufferToggle<CR>
endif

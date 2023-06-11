if utils#hasplug('tagbar')
    let g:tagbar_width = 30
    let g:tagbar_sort = 0
    let g:tagbar_compact = 2
    let g:tagbar_autoshowtag = 1
    let g:tagbar_foldlevel = 99 
    let g:tagbar_no_status_line = 1
    let g:tagbar_visibility_symbols = {
        \ 'public'    : '+',
        \ 'protected' : '#',
        \ 'private'   : '-'
        \ }
    nnoremap <silent> <leader>v <cmd>TagbarToggle<CR>
endif

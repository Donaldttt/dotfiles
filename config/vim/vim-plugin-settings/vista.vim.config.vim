
if utils#hasplug('vista.vim')
    let g:vista_default_executive = 'vim_lsp'
    if utils#hasplug('coc.nvim')
        let g:vista_default_executive = 'coc'
    elseif executable('ctags')
        let g:vista_default_executive = 'ctags'
    endif
    nnoremap <silent> <leader>v :Vista!!<CR>
    let g:vista_cursor_delay = 0
    let g:vista_echo_cursor = 0
    let g:vista_echo_cursor_strategy = 'floating_win'
    let g:vista_close_on_jump = 0
    let g:vista_floating_delay = 0
    let g:vista_ignore_kinds = ['Variable', 'Field', 'EnumMember',
                \ 'String', 'Object', 'Array', 'Constant', 'Package', 'Boolean', 'Number'
                \ ]
    let g:vista_floating_border = 'rounded'
    let g:vista_disable_statusline = 1
    " let g:vista_keep_fzf_colors = 1
    let g:vista_update_on_text_changed_delay = 0
    let g:vista_update_on_text_changed = 1
    let g:vista#renderer#enable_kind = 1
    let g:vista#renderer#enable_icon = 1

    " return to last position of vista
    let g:vista_last_row = v:null
    function! VistaCursorJump()
        " let found = vista#util#BinarySearch(g:vista.raw, line('.'), 'line', '')
        let found = g:vista_last_row
        if empty(found)
            return
        endif
        let vlnum = get(found, 'vlnum', v:null)
        call cursor(vlnum, 3)
    endfunction

    " save tag for VistaCursorJump use
    function! VistaH2()
        if exists('*vista#util#BinarySearch')
            let bufs = map(filter(copy(getbufinfo()), 'v:val.listed'), 'v:val.bufnr')
            if index(bufs, bufnr('%')) < 0
                return
            endif
            let found = vista#util#BinarySearch(g:vista.raw, line('.'), 'line', '')
            if empty(found)
                return
            endif
            let g:vista_last_row = found
        endif
    endfunction

    augroup VistaAu
        autocmd!
        autocmd BufLeave * call VistaH2()
        autocmd FileType vista call VistaCursorJump()
    augroup END

endif



if utils#hasplug('vim-floaterm')
    let g:floaterm_keymap_toggle = '<C-\>'
    let g:floaterm_wintype = 'float'
    let g:floaterm_position = 'bottomright'
    let g:floaterm_width = 0.5
    let g:floaterm_height = 0.5
    let g:floaterm_autohide = 2

    call theme#addCleanBg(['FloatermBorder', 'Floaterm'])

    autocmd QuitPre * :FloatermKill!<CR>

    " press <c-[> ener normal mode in terminal. autocmd prevent this key map
    " in other plugin like fzf
    autocmd FileType floaterm tmap <buffer> <C-[> <C-w>N

    function! s:hasterm(name)
        let bufs = floaterm#buflist#gather()
        for bufnr in bufs
            let bufinfo = getbufinfo(bufnr)[0]
            let termname = bufinfo['variables']['floaterm_name']
            if termname == a:name
                return v:true
            endif
        endfor
        return v:false
    endfunction

    function! ToggleRepl()
        let name = 'REPL'
        let currentWindow=winnr()
        if s:hasterm(name)
            execute('FloatermToggle ' . name)
        else
            :FloatermNew --name=REPL --width=0.5 --wintype=vsplit --position=botright --autoclose=2 ipython
        endif
        exe currentWindow . "wincmd w"
    endfunction

    function! ToggleNormal()
        let name = 'normalterm'
        if s:hasterm(name)
            execute('FloatermToggle ' . name)
        else
            :FloatermNew --name=normalterm --width=0.5 --height=0.5 --wintype=float --position=bottomright --autoclose=2
        endif
    endfunction

    nnoremap <silent> <leader>tp :call ToggleRepl()<CR>
    nnoremap <silent> <leader>tn :call ToggleNormal()<CR>
    vnoremap <silent> <leader>tl :FloatermSend --name=REPL<CR>
endif

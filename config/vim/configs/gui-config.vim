if has('gui') || exists('g:neovide')
    set guifont=Hack\ Nerd\ Font:h13

    " neovide doesn't support copy from host, so we have to map it ourselves

    if exists('g:neovide')

        func! s:enabletp()
            let g:neovide_transparency=0.9
        endfunc
        func! s:disabletp()
            let g:neovide_transparency=1.0
        endfunc
        let g:Transparent_disable_func = function('s:disabletp')
        let g:Transparent_enable_func = function('s:enabletp')

        let g:neovide_transparency=0.9
        " let g:neovide_transparency_point=0.8
        if g:os == 'Darwin'
            nnoremap <D-v> "+p
            cnoremap <D-v> <c-r>+
            inoremap <D-v> <c-r>+
        else
            nnoremap <C-v> "+p
            cnoremap <C-v> <c-r>+
            inoremap <C-v> <c-r>+
        endif
    endif

endif

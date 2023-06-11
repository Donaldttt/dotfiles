if utils#hasplug('nerdtree')
    if utils#hasplug('vim-nerdtree-syntax-highlight')
        let g:NERDTreeLimitedSyntax = 1
    endif
    let g:NERDShutUp=1

    " work around for nerdtree bug: https://github.com/preservim/nerdtree/issues/1321
    let g:NERDTreeMinimalMenu = v:true
    let g:NERDTreeMinimalUI = v:true

    function! NERDTreeFindToggle()
        let has_nerdtree = 0
        let winfo = getwininfo()
        for obj in winfo
            let bufnr = obj['bufnr']
            let ft = getbufvar(bufnr, '&filetype')
            if ft == 'nerdtree'
                let has_nerdtree = 1
                break
            endif
        endfor
        if has_nerdtree
            :NERDTreeClose
        else
            " we cannot use NERDTreeFind on startify as it is not a file
            if &ft == 'startify' || &ft == ''
                :NERDTreeToggle
            else
                :NERDTreeFind
                " NERDTreeToggleVCS
            endif
        endif
    endfunction
    nnoremap <silent> <leader>e :call NERDTreeFindToggle()<CR>

    "let NERDTreeShowBookmarks=1
    let NERDTreeChDirMode        = 0
    let NERDTreeQuitOnOpen       = 1
    let NERDTreeMouseMode        = 2
    let NERDTreeShowHidden       = 1

    " remapping
    let g:NERDTreeMapOpenExpl = ''
    if utils#hasplug('vim-devicons') || utils#hasplug('nerdfont.vim')
        let NERDTreeDirArrowCollapsible = ''
        let NERDTreeDirArrowExpandable = ''
    else
        " let NERDTreeDirArrowCollapsible = ''
        " let NERDTreeDirArrowExpandable = ''
    endif
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
endif

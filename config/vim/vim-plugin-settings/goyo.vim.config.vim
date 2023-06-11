
if utils#hasplug('goyo.vim')
    nnoremap <leader><leader>g :Goyo<CR>
    let g:goyo_width= floor(&co * 0.65)

    function! s:fix()
        " resize the goyo after being messed up by other plugins
        au BufEnter * if winnr('$') == '5' | exe "normal \<c-w>=" | endif
    endfunction
    augroup GoyoAu
        au!
    augroup END

    autocmd User GoyoEnter au GoyoAu BufEnter * if winnr('$') == '5' | exe "normal \<c-w>=" | endif
    autocmd User GoyoLeave augroup GoyoAu | au! | augroup END
endif

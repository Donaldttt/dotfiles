if utils#hasplug('vimtex')
    noremap <leader>lc :VimtexCompile<CR>
    noremap <leader>lv :VimtexView<CR>
    if g:os == 'Darwin'
        let g:vimtex_view_method = 'skim'
    endif
endif

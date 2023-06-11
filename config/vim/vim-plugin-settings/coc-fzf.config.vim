
if utils#hasplug('coc-fzf')

    let g:coc_fzf_preview = 'right:50%'
    nnoremap <silent> <leader>fs :CocFzfList outline<CR>
    let s:preview_exe = expand(g:dotvimdir.'/bin/preview.py')
    let g:coc_fzf_opts = ['--border-label', 'Coc Outlines', '--border-label-pos', '9', '--no-scrollbar', '--no-hscroll', '--no-separator']
endif

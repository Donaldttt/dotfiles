
if utils#hasplug('everforest')
    let g:everforest_better_performance = 1
    let g:everforest_background = 'hard'
    " let g:everforest_enable_italic = 1
    function! Everforest_trans_enable()
        let g:everforest_transparent_background = 2
        colorscheme everforest
        call theme#setStlColor(&background, 'everforest')
        " hack to fix caret characters appearing in the statusline when StatusLine
        " and StatusLineNC has same highlight(https://vi.stackexchange.com/questions/15873/carets-in-status-line)
        hi StatusLine guifg=#d3c6aa ctermfg=223
    endfunction
    function! Everforest_trans_disable()
        let g:everforest_transparent_background = 0
        colorscheme everforest
        call theme#setStlColor(&background, 'everforest')
    endfunction
    function! CB_dark_tb_enable_everforest()
        call Everforest_trans_enable()
    endfunction
    function! CB_light_tb_enable_everforest()
        call Everforest_trans_enable()
    endfunction
    function! CB_dark_tb_disable_everforest()
        call Everforest_trans_disable()
    endfunction
    function! CB_light_tb_disable_everforest()
        call Everforest_trans_disable()
    endfunction

endif

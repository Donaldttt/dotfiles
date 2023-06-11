
if utils#hasplug('papercolor-theme')
    function! CB_dark_tb_enable_PaperColor()
        let g:PaperColor_Theme_Options = {
        \   'theme': {'default.dark': { 'transparent_background': 1 }}}
        colorscheme PaperColor
    endfunction
    function! CB_light_tb_enable_PaperColor()
        let g:PaperColor_Theme_Options = {
        \   'theme': {'default.light': { 'transparent_background': 1 }}}
        colorscheme PaperColor
    endfunction
    function! CB_dark_tb_disable_PaperColor()
        let g:PaperColor_Theme_Options = {
        \   'theme': {'default.dark': { 'transparent_background': 0 }}}
        colorscheme PaperColor
    endfunction
    function! CB_light_tb_disable_PaperColor()
        let g:PaperColor_Theme_Options = {
        \   'theme': {'default.light': { 'transparent_background': 0 }}}
        colorscheme PaperColor
    endfunction
endif



if utils#hasplug("vim-bufferline")
    let g:bufferline_echo = 0
    let g:bufferline_modified = '+'

    " scrolling with fixed current buffer position

    let g:bufferline_active_buffer_left = '['
    let g:bufferline_active_buffer_right = ']'
    if utils#hasplug("vim-airline")
        let g:bufferline_inactive_highlight = 'airline_c'
        let g:bufferline_active_highlight = 'airline_c_bold'
    elseif ! utils#hasplug("vim-global-statusline")
        call bufferline#init_echo()
    endif
endif



if utils#hasplug('vim-tmux-navigator')
    let g:tmux_navigator_no_mappings = 1

    noremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
    noremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
    noremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
    noremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
    " noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>
endif


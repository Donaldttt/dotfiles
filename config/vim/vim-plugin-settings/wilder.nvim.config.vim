
if utils#hasplug('wilder.nvim')

    call wilder#setup({
        \ 'modes': [':'],
        \ 'next_key': '<tab>',
        \ 'previous_key': '<S-Tab>',
        \ 'enable_cmdline_enter': 0,
        \ })

    call wilder#set_option('pipeline', [
        \   wilder#debounce(10),
        \   wilder#branch(
        \     wilder#cmdline_pipeline({'language': g:vim_type == 'nvim' ? 'python' : 'vim'}),
        \   ),
        \ ])

    if g:vim_type == 'vim'
        call wilder#set_option('renderer', wilder#popupmenu_renderer())
    else
        call wilder#set_option('renderer', wilder#popupmenu_renderer(
            \ wilder#popupmenu_border_theme({
            \ 'highlights': {
            \   'default': 'Normal',
            \ },
            \ 'pumblend': 20,
            \ 'border': 'rounded',
            \ })))
    endif
endif


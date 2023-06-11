
if utils#hasplug("vim-startify")
    if has('nvim')
        let buffer_str_len = (&columns - 60) / 2
        let buf_str = repeat(' ', buffer_str_len)
        let ascii_art = [
            \ buf_str . '',
            \ buf_str . '',
            \ buf_str . ' __    __  ________   ______   __     __  ______  __       __ ',
            \ buf_str . '|  \  |  \|        \ /      \ |  \   |  \|      \|  \     /  \',
            \ buf_str . '| $$\ | $$| $$$$$$$$|  $$$$$$\| $$   | $$ \$$$$$$| $$\   /  $$',
            \ buf_str . '| $$$\| $$| $$__    | $$  | $$| $$   | $$  | $$  | $$$\ /  $$$',
            \ buf_str . '| $$$$\ $$| $$  \   | $$  | $$ \$$\ /  $$  | $$  | $$$$\  $$$$',
            \ buf_str . '| $$\$$ $$| $$$$$   | $$  | $$  \$$\  $$   | $$  | $$\$$ $$ $$',
            \ buf_str . '| $$ \$$$$| $$_____ | $$__/ $$   \$$ $$   _| $$_ | $$ \$$$| $$',
            \ buf_str . '| $$  \$$$| $$     \ \$$    $$    \$$$   |   $$ \| $$  \$ | $$',
            \ buf_str . ' \$$   \$$ \$$$$$$$$  \$$$$$$      \$     \$$$$$$ \$$      \$$',
            \]
    else
        let buffer_str_len = (&columns - 30) / 2
        let buf_str = repeat(' ', buffer_str_len)
        let ascii_art = [
            \ buf_str . '',
            \ buf_str . '',
            \ buf_str . ' __     __  ______  __       __ ',
            \ buf_str . '|  \   |  \|      \|  \     /  \',
            \ buf_str . '| $$   | $$ \$$$$$$| $$\   /  $$',
            \ buf_str . '| $$   | $$  | $$  | $$$\ /  $$$',
            \ buf_str . ' \$$\ /  $$  | $$  | $$$$\  $$$$',
            \ buf_str . '  \$$\  $$   | $$  | $$\$$ $$ $$',
            \ buf_str . '   \$$ $$   _| $$_ | $$ \$$$| $$',
            \ buf_str . '    \$$$   |   $$ \| $$  \$ | $$',
            \ buf_str . '     \$     \$$$$$$ \$$      \$$',
            \]
    endif

    let g:startify_padding_left = &columns / 2 - &columns / 4 - &columns / 8
    let g:startify_custom_header = ascii_art
    let g:startify_change_to_dir = 0
    let g:startify_files_number = 5

    let g:startify_bookmarks = [ g:dotfiledir . 'main.vim' ]
    let g:startify_lists = [
        \ { 'header': startify#pad(['   RECENT']),            'type': 'files' },
        \ { 'header': startify#pad(['   SESSIONS']),       'type': 'sessions' },
        \ { 'header': startify#pad(['   BOOKMARKS']),       'type': 'bookmarks' },
    \ ]

    " session related KeyBinding. These KeyBinding uses function from startify
    nnoremap <silent> <leader><leader>s :SSave!<CR>
    nnoremap <silent> <leader><leader>l :SLoad<CR>
    nnoremap <silent> <leader><leader>d :SDelete!<CR>
    nnoremap <silent> <leader><leader>c :SClose<CR>

    au VimLeave * SSave! last

endif


" vim build with clipboard support doesn't need this and it work
" better than neovim

func s:helper()
    call system('printf "%s" '.shellescape(join(v:event['regcontents'], "\n")).' | xclip -sel clip' )
endfunc

func! clipboard#get()
endfunc

func! clipboard#enable()
    augroup WSLClipboard
        au!
        au TextYankPost * call s:helper()
    augroup END
endfunc

func! clipboard#disable()
    augroup WSLClipboard
        au!
    augroup END
endfunc

func! clipboard#paste()
    return system('xclip -o -sel clip' )
endfunc


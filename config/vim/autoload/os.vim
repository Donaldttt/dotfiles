func! os#getOS()
    if has("win64") || has("win32") || has("win16")
        return "Windows"
    else
        return substitute(system('uname'), '\n', '', '')
    endif
endfunc


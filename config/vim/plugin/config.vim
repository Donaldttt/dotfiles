
if exists("g:loaded_vim_config")
  finish
endif
let g:loaded_vim_config = 1

let os = os#getOS()

if os == 'Windows'
    call os#setWindows()
endif

call options#init()

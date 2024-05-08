
if exists("g:loaded_vim_config")
  finish
endif
let g:loaded_vim_config = 1

let os = os#getOS()

call options#init()

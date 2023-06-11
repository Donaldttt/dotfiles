let s:path = get(g:, '_config_path', fnamemodify(
    \ resolve(expand('<sfile>:p')), ':h:h').'/_config.vim')
let s:config = {}

function! config#saveConfig()
    let p = utils#readvar(s:path)
    if type(p) != type({})
        let p = {}
    endif
    let vim_type = has('nvim') ? 'nvim' : 'vim'
    let config = has_key(p, vim_type) && type(p[vim_type]) == v:t_dict
        \ ? p[vim_type] : {}
    let config = utils#merge(config, s:config)

    " vim and nvim may have diferenrt available plugins
    let p[vim_type] = config
    call utils#savevar(p, s:path)
endfunction

function! s:loadConfig()
    let result = utils#readvar(s:path)
    " if it is dictionary
    let vim_type = has('nvim') ? 'nvim' : 'vim'
    if type(result) == v:t_dict
        if has_key(result, vim_type)
            let config = result[vim_type]
            if type(config) == v:t_dict
                let s:config = config
                return
            endif
        endif
    endif
endfunction

function! config#setConfig(dict)
    let s:config = utils#merge(s:config, a:config)
endfunction

function! config#init()
    call config#loadConfig()
    augroup config
        autocmd!
        autocmd VimLeave * call config#saveConfig()
    augroup END
endfunction

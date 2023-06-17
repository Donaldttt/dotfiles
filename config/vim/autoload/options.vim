
" this intent to create a list of options that can be toggled on/off

let s:options = {}

if !has('nvim')
    import autoload 'utils/selector.vim'
endif

" opt is a dictionary with the following keys(* = required):
" togglefunc and enablefunc/disablefunc are mutually exclusive
" params:
"   - name: name of the option
"   - opt: a dictionary with following options():
"     - desc: description,
"     - togglefunc: function reference, if exists, enablefunc and disablefunc
"       will be ignored,
"     - enablefunc: function reference, if this exists, disablefunc must exists
"       as well and vice verse
"     - disablefunc: function reference,
"     - isEnabled: string, true or false or function reference. only needed when
"       using enablefunc and disablefunc
function! options#add(name, opt) abort
    if (!has_key(a:opt, 'togglefunc')
        \ && (!has_key(a:opt, 'enablefunc') || !has_key(a:opt, 'disablefunc')))
        throw 'invalid option (togglefunc or enablefunc/disablefunc must be set))'
    endif

    if !has_key(a:opt, 'isEnabled') && !has_key(a:opt, 'togglefunc')
        throw 'specify initial state(isEnabled) or set togglefunc'
    endif

    for key in ['togglefunc', 'enablefunc', 'disablefunc']
        if has_key(a:opt, key) && type(a:opt[key]) != v:t_func
            throw key . ' must be a function reference'
        endif
    endfor

    if !has_key(a:opt, 'desc')
        let a:opt['desc'] = ''
    endif

    let s:options[a:name] = a:opt
endfunction

" Register a simple vim option
" params:
"   - name: name of the option
"   - dictionary(optional):
"       - desc: description of the option
function! options#addVimOption(name, ...) abort
    let opt = {}

    func opt.togglefunc(key)
        if eval('&' . a:key)
            execute('set no' . a:key)
        else
            execute('set ' . a:key)
        endif
    endfunc

    if a:0 > 0
        let opt['desc'] = a:1
    endif

    call options#add(a:name, opt)
endfunction

function! options#getAll() abort
    let list = []
    for [key, val] in items(s:options)
        let desc = val.desc != '' ? ' - ' . val.desc : ''
        call add(list, [key, key . desc])
    endfor
    return list
endfunction

function! options#getAllRaw() abort
    let list = []
    for [key, val] in items(s:options)
        call add(list, [key, desc])
    endfor
    return list
endfunction

function! options#toggle(name) abort
    if !has_key(s:options, a:name)
        throw 'invalid option name: ' . a:name
    endif

    let opt = s:options[a:name]
    if has_key(opt, 'togglefunc')
        call opt.togglefunc(a:name)
    else
        if type(opt.isEnabled) == v:t_func
            let isEnabled = opt.isEnabled()
        else
            let isEnabled = opt.isEnabled
        endif
        if isEnabled
            call opt.disablefunc()
        else
            call opt.enablefunc()
        endif
        if type(opt.isEnabled) != v:t_func
            let s:options[a:name].isEnabled = opt.isEnabled ? v:false : v:true
        endif
    endif
endfunction

function! options#preSet()
    call options#addVimOption('number', 'show line number')
    call options#addVimOption('relativenumber')

    let colorcolumnOpt = {
        \ 'desc': 'show color column',
        \ 'isEnabled': &colorcolumn != ''
        \ }
    function colorcolumnOpt.togglefunc(...)
        if &colorcolumn == ''
            let &colorcolumn = '80'
        else
            let &colorcolumn = ''
        endif
    endfunction

    call options#add('colorcolumn', colorcolumnOpt)

    let toggleBgOpt = {
        \ 'desc': 'toggle dark/light theme',
        \ }
    function toggleBgOpt.togglefunc(...)
        call theme#toggleBg()
    endfunction
    call options#add('dark/light', toggleBgOpt)
endfunction

function! s:select(wid, result)
    let result = a:result[0]
    if result != v:null
        let key = s:rmap[result]
        call options#toggle(key)
    endif
endfunction

function! options#fzf_options()
    let list = []
    let s:rmap = {}
    for [key, val] in items(s:options)
        let desc = val.desc != '' ? key . ' - ' . val.desc : key
        call add(list, desc)
        let s:rmap[desc] = key
    endfor
    let s:fzf_list = list
    call selector.Start( list,
    \ {
    \ 'select_cb' :  function('s:select'),
    \ 'yoffset'   :  0.3,
    \ 'height'    :  0.4,
    \ 'title'     :  'Options',
    \ 'width'     :  0.4
    \ })
endfunc

function! options#init()
    call options#preSet()
    if !has('nvim')
        command! -nargs=0 Options call options#fzf_options()
        nnoremap <silent> <leader>fo :Options<CR>
    endif
endfunction

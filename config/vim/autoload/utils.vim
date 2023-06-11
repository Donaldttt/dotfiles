
" return a python version available (from 3 to 2)
fun! utils#get_usable_py()
    let py = ''
    if executable('python3')
        let py = 'python3'
    elseif executable('python2')
        let py = 'python2'
    elseif executable('python')
        let py = 'python'
    endif
    return py
endfun

" Check if plugin exists
function! utils#hasplug(plug_name, ...)
    let plug_dir_name = get(a:, 1, a:plug_name) " optional argument for the name of plug's folder
    if has_key(g:plugs, a:plug_name) && isdirectory(g:plugin_dir . "/" . plug_dir_name)
        if has_key(g:plugs[a:plug_name], 'for') || has_key(g:plugs[a:plug_name], 'on')
            if (has_key(g:plugs[a:plug_name], 'for') && len(g:plugs[a:plug_name]['for']) == 0) ||
                        \ (has_key(g:plugs[a:plug_name], 'on') && len(g:plugs[a:plug_name]['on']) == 0)
                return v:false
            endif
        endif
        return v:true
    endif
    return v:false
endfunction

" This function is used to save a variable to a file
function! utils#savevar(var, file)
    let serialized = string(a:var)
    call writefile([serialized], a:file)
endfun

" This function is used to retrieve a variable from a file
" only first line is count
function! utils#readvar(file)
    if !filereadable(a:file)
        return v:null
    endif
    let serialized = readfile(a:file)
    if(len(serialized) == 0)
        return v:null
    endif
    execute "let result = " . serialized[0]
    return result
endfun

" Merge two dictionaries, also recursively merging nested keys.
" Use extend() if you don't need to merge nested keys.
fun! utils#merge(defaults, override)
  let l:new = copy(a:defaults)
  for [l:k, l:v] in items(a:override)
    let l:new[l:k] = (type(l:v) is v:t_dict && type(get(l:new, l:k)) is v:t_dict)
          \ ? utils#merge(l:new[l:k], l:v)
          \ : l:v
  endfor
  return l:new
endfun

"Remove all trailing whitespace by pressing <leader>ws
fun! utils#trimwhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s*\r\=$//e
    call winrestview(l:save)
endfun

function! utils#hascolorscheme(name)
    let scheme = a:name
    let colors = globpath(&runtimepath, printf('colors/%s.vim', scheme), 1, 1)
    if len(colors) > 0 | return 1 | endif
    let colors += globpath(&packpath, printf('pack/*/start/*/colors/%s.vim', scheme), 1, 1)
    if len(colors) > 0 | return 1 | endif
    let colors += globpath(&packpath, printf('pack/*/opt/*/colors/%s.vim', scheme), 1, 1)
    if len(colors) > 0 | return 1 | endif
    if has('nvim')
        let colors = globpath(&runtimepath, printf('colors/%s.lua', scheme), 1, 1)
        if len(colors) > 0 | return 1 | endif
        let colors += globpath(&packpath, printf('pack/*/start/*/colors/%s.lua', scheme), 1, 1)
        if len(colors) > 0 | return 1 | endif
        let colors += globpath(&packpath, printf('pack/*/opt/*/colors/%s.lua', scheme), 1, 1)
        if len(colors) > 0 | return 1 | endif
    endif
    return 0
endfunction

" get current colorscheme name
" return default if not found
function! utils#colorschemename()
    return execute('colo')[1:]
    try
        return g:colors_name
    catch /^Vim:E121/
        return "default"
    catch /.*/
        return "default"
    endtry
endfunction

" debug function print out highlight group of cursor position
function! utils#showHiGroup(...)
    if !exists("*synstack")
        return
    endif
    let l = a:0 == 2 ? a:1 : line('.')
    let c = a:0 == 2 ? a:2 : col('.')
    echo map(synstack(l, c), 'synIDattr(v:val, "name")')

    :echo "hi<" . synIDattr(synID(l,c,1),"name") . '> trans<'
    \ . synIDattr(synID(l,c,0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(l,c,1)),"name") . ">"

endfunc

" get highlight group information and return as dictionary
function! utils#getHi(group)
  let output = execute('hi ' . a:group)
  let list = split(output, '\s\+')
  let dict = {}
  for item in list
    if match(item, '=') > 0
      let splited = split(item, '=')
      let dict[splited[0]] = splited[1]
    endif
  endfor
  return dict
endfunction 

function! utils#isTransparent()
    let dict = utils#getHi('Normal')
    let isGui = &termguicolors
    if isGui 
        if !has_key(dict, 'guibg')
            return 1
        endif
    elseif !isGui
        if !has_key(dict, 'ctermfg')
            return 1
        endif
    endif
    return 0
endfunction

function! s:scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nobuflisted
endfunction

" search highlight group with pattern
function! utils#searchHi(pattern)
    execute("filter /" . a:pattern . "/ highlight")
    " color not working
    " let temp_reg = @"
    " redir @"
    " silent! execute("filter /" . a:pattern . "/ highlight")
    " redir END
    " let output = copy(@")
    " let @" = temp_reg
    " call s:scratch()
    " put! =output
endfunc

function! utils#swapword()
    let word = expand("<cword>")
    let l1 = g:swap_dict[0]
    let l2 = g:swap_dict[1]
    let inx = index(l1, word)
    if inx != -1
        let newword = l2[inx]
    else
        let inx = index(l2, word)
        if inx != -1
            let newword = l1[inx]
        endif
    endif
    if inx != -1
        execute "normal ciw" . newword . "\<Esc>"
    endif
endfunction

function! utils#files(...)
    if a:0 > 0
        let path = a:1
    else
        let path = getcwd()
    endif
    let files = glob(path . '/**', 1, 1, 1)
    return files
endfunction


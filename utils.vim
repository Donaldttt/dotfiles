
" This file stores helper functions

function! Notify(msg)
    echo msg
endfunction

" This function is used to save a variable to a file
function! SaveVariable(var, file)
    let serialized = string(a:var)
    call writefile([serialized], a:file)
endfun

" This function is used to retrieve a variable from a file
" only first line is count
function! ReadVariable(file)
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
fun! Merge(defaults, override)
  let l:new = copy(a:defaults)
  for [l:k, l:v] in items(a:override)
    let l:new[l:k] = (type(l:v) is v:t_dict && type(get(l:new, l:k)) is v:t_dict)
          \ ? Merge(l:new[l:k], l:v)
          \ : l:v
  endfor
  return l:new
endfun

function! Sh(pattern)
    execute("filter /" . a:pattern . "/ highlight")
endfunc

" get current colorscheme name
function! ColourSchemeName()
    try
        return g:colors_name
    catch /^Vim:E121/
        return "default"
    catch /.*/
        return "default"
    endtry
endfunction

" debug function print out highlight group of cursor position
function! ShowHighLightGroup()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

    :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

endfunc

" get highlight group information and return as dictionary
function! GetHighlight(group)
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

function! InTransparentMode()
    let dict = GetHighlight('Normal')
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

function! HasColorscheme(name)
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

" delete signal file if exist
function! DeleteSignalFile(name)
    if filereadable(g:vim_dir . a:name)
        call delete(g:vim_dir . a:name)
    endif
endfunction

" Create signal file if not exist
function! CreateSignalFile(name)
    call system("touch " . g:vim_dir . a:name)
endfunction

function! SignalFileExists(filename)
    if filereadable(g:vim_dir . a:filename)
        return v:true
    endif
    return v:false
endfunction

" Debug related
if g:debug_mode
    let g:debug_logs = []

    function! Debugstats()
        let d = {}
        let d['filetype'] = &ft
        let d['buftype'] = &buftype
        let d['winid'] = win_getid()
        return d
    endfunction
endif


" Swap values under cursor according to g:swap_dict
" {
function SwapWord()
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

" }

function! GenVimAsciiArt(buffer_str_len)
    let buf_str = repeat(' ', a:buffer_str_len)
    if has('nvim')
        let ascii_art = [
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
        let ascii_art = [
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
    return ascii_art
endfunction

"Remove all trailing whitespace by pressing <leader>ws
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

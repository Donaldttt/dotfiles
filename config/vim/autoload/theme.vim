let s:path = get(g:, 'theme_config_path', fnamemodify(
    \ resolve(expand('<sfile>:p')), ':h:h').'/theme_config.vim')

let s:themefixes = []

let s:bgType = has('termguicolors') ? 'guibg' : 'ctermbg'

" sometimes even in termguicolors, when guibg is not set, the bg will fall
" back to use ctermbg, so we have to set them both to none
let s:bgNonType = !has('termguicolors') ? 'guibg=NONE' : 'ctermbg=NONE'
let s:transBlendOpt = has('nvim') ? ' blend=0' : ''

let s:default_config = {
    \ 'background': 'dark',
    \ 'light': {
    \   'theme': 'sunbather_light',
    \   'default': 'sunbather_light',
    \   'transparent': v:false,
    \   'airline_theme': 'sunbather_light',
    \ },
    \ 'dark': {
    \   'theme': 'base16-harmonic-dark',
    \   'default': 'base16-harmonic-dark',
    \   'transparent': v:false,
    \   'airline_theme': 'base16-harmonic-dark',
    \ },
\ }

" When enable transparent background, these group will be set to transparent
let s:transgroups = [
        \ 'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        \ 'Folded', 'Statusline', 'StatuslineNC',
        \ 'Statement', 'PreProc', 'Type', 'Underlined', 'String', 'Function',
        \ 'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        \ 'SignColumn', 'CursorLineNr', 'EndOfBuffer', 'VertSplit',
        \ 'DiagnosticSignWarn', 'DiagnosticSignError', 'DiagnosticSignInfo',]

" background group that will be set to normal's background color
let s:cleanbg = ['DiagnosticSignWarn', 'DiagnosticSignError', 'DiagnosticSignInfo',
        \ 'VertSplit', 'LineNr', 'SignColumn', 'NormalFloat']

let s:config = get(g:, 'theme_config', s:default_config)

function! theme#setConfig(bg, key, value)
    let s:config[a:bg][a:key] = a:value
endfunction
" register extra transparent hi group
function! theme#getCleanBg()
    return s:cleanbg
endfunction

function! theme#getBgType()
    return s:bgType
endfunction

function! theme#getTransGroup()
    return s:transgroups
endfunction

" register extra transparent hi group
function theme#addCleanBg(group)
    let li = type(a:group) == 1 ? [a:group] : a:group
    for hi in li
        if index(s:cleanbg, hi) == -1
            call add(s:cleanbg, hi)
        endif
    endfor
endfunction

" register extra transparent hi group
function theme#addTransGroup(group)
    let li = type(a:group) == 1 ? [a:group] : a:group
    for hi in li
        if index(s:transgroups, hi) == -1
            call add(s:transgroups, hi)
        endif
    endfor
endfunction

function! theme#setColor(bg, ...)
    let colors_name = a:0 > 0 ? a:1 : s:config[a:bg].theme
    if !utils#hascolorscheme(colors_name)
        let colors_name = 'default'
    endif
    noa let &bg = a:bg
    call theme#setStlColor(a:bg)
    let s:config.background = a:bg
    let s:config[a:bg].theme = colors_name
    noa execute("colorscheme " . colors_name)
    if &background != a:bg
        noa let &bg = a:bg
    endif
    " some theme will pick their own airline theme or airline will
    " automatically pick theme based on colorscheme
    if exists('g:airline_theme') && g:airline_theme != s:config[a:bg].airline_theme
        call theme#setStlColor(a:bg, g:airline_theme)
    endif
endfunction

" Change bottom airline/lualine theme
function! theme#setStlColor(bg, ...)
    if has('nvim-0.5')
        " lualine will change theme automatically
    else
        if utils#hasplug('vim-airline') && exists(':AirlineTheme')
            let theme = a:0 > 0 ? a:1 : s:config[a:bg].airline_theme
            try
                execute('AirlineTheme ' . theme)
            catch
                let theme = s:default_config[a:bg].airline_theme
                execute('AirlineTheme ' . theme)
            endtry
            let s:config[a:bg].airline_theme = theme
        endif
    endif
endfunction

function! theme#inTransparent()
    return s:config[&background].transparent
endfunction

" return 1 if link to other group
" return 2 if not exists
" return 0 if normal
function! s:hiType(group)
    try
        let hi = execute('hi '.a:group)
        if hi =~# 'link'
            return 2
        endif
    catch
        return 1
    endtry
    return 0
endfunction

function s:applyTransparent()
    let tail = ' ' . s:bgType . '=NONE term=NONE gui=NONE cterm=NONE '
    if has('nvim')
        let tail .= s:transBlendOpt
    else
        let tail .= s:bgNonType
    endif
    for group in s:transgroups
        if s:hiType(group) != 0
            continue
        endif
        " cterm and term sometimes are set to reverse so we need to clean them
        " too
        " for the last part, we can't clear all terms or it will fall back to
        " default which is not transparent
        execute('hi! '.group . tail)
    endfor
    call s:generalThemeFix()
    " for group in s:cleanbg
    "     if s:hiType(group) != 0
    "         continue
    "     endif
    "     execute('hi! '.group . tail)
    " endfor
endfunction

" some callback function to enable transparent background
" for specific colorscheme

" or general callback for all colorscheme when specific colorscheme callback
" is not available
" g:dark_transparent_enable_cb
" g:light_transparent_enable_cb

function! theme#enableTransparent() abort
    let colorscheme_name = utils#colorschemename()
    let bg = &background
    if exists('g:'.bg.'_transparent_enable_cb') && g:dark_transparent_enable_cb != ''
        let cb_name = get(g:, bg.'_transparent_enable_cb', '')
        if cb_name != ''
            execute('call '.cb_name.'()')
        endif
    elseif exists('g:Transparent_enable_func')
        if type(g:Transparent_enable_func) != v:t_func
            echoerr 'g:Transparent_enable_func is not a function'
        endif
        call g:Transparent_enable_func()
    else
        call s:applyTransparent()
        augroup SetTransparent
            autocmd!
            autocmd ColorScheme * call s:applyTransparent()
        augroup END
    endif
    let s:config[bg].transparent = v:true
endfunction

function! theme#disableTransparent() abort
    augroup SetTransparent
        autocmd!
    augroup END
    let bg = &background
    let s:config[bg].transparent = v:false
    let colorscheme_name = utils#colorschemename()
    if exists('g:'.bg.'_transparent_disable_cb')
        let cb_name = get(g:, bg.'_transparent_disable_cb', '')
        if cb_name != ''
            execute('call '.cb_name.'()')
        endif
    elseif exists('g:Transparent_disable_func')
        if type(g:Transparent_disable_func) != v:t_func
            echoerr 'g:Transparent_disable_func is not a function'
        endif
        call g:Transparent_disable_func()
    else
        execute('colorscheme ' . s:config[bg].theme)
    endif
endfunction

" ToggleTransparent background
function! theme#toggleTransparent()
    if s:config[&background].transparent
        call theme#disableTransparent()
    else
        call theme#enableTransparent()
    endif
endfunction

" Allow to trigger background
function! theme#toggleBg()
    " Inversion
    let newbg = &background == "dark" ? 'light' : 'dark'
    call theme#setColor(newbg)
    if s:config[&background].transparent
        call theme#enableTransparent()
    elseif !s:config[&background].transparent
        call theme#disableTransparent()
    endif
endfunction

function! theme#saveConfig()
    let p = utils#readvar(s:path)
    if type(p) != type({})
        let p = {}
    endif

    let vim_type = has('nvim') ? 'nvim' : 'vim'

    let config = has_key(p, vim_type) && type(p[vim_type]) == 4
        \ ? p[vim_type] : {}

    let config = utils#merge(config, s:config)

    " vim and nvim may have diferenrt available plugins
    let p[vim_type] = config
    call utils#savevar(p, s:path)
endfunction

function! theme#loadConfig()
    let result = utils#readvar(s:path)
    " if it is dictionary
    let vim_type = has('nvim') ? 'nvim' : 'vim'
    if type(result) == 4
        if has_key(result, vim_type)
            let config = result[vim_type]
            if type(config) == 4
                return config
            endif
        endif
    endif
    return {}
endfunction

function! theme#getHiTerms(group)
    let output = execute('hi ' . a:group)
    if stridx(output, 'links to') > 0
        let higroup = matchstr(output, 'links.to.\?\zs\S\+\ze')
        return theme#getHiTerms(higroup)
    endif
    let list = split(output, '')
    let dict = {}

    for item in list
        if stridx(item, '=') > 0
              let splited = split(item, '=')
              let dict[splited[0]] = splited[1]
        endif
    endfor

    for item in ['guibg', 'ctermbg', 'term', 'cterm', 'guifg', 'ctermfg']
        if ! has_key(dict, item)
            let dict[item] = 'NONE'
        endif
    endfor
    return dict
endfunction

function! theme#getHiTerm(group, term)
   " Store output of group to variable
    let output = theme#getHiTerms(a:group)
    return output[a:term]
endfunction

function! s:regiesterThemeFix(Func)
    call add(s:theme_fix, a:Func)
endfunction

function! s:generalThemeFix()
" The following is for getting rid of the vim split bar and match its
" and number cols' color with backgroud
    " if theme#inTransparent()
    "     return
    " endif
    if &bg != s:config.background
        execute('set bg=' . s:config.background)
    endif

    let normal = theme#getHiTerms('normal')
    let hiTerms = ' '
    for term in ['guibg', 'ctermbg', 'term', 'cterm']
        let hiTerms .= term . '=' . normal[term] . ' '
    endfor

    for group in s:cleanbg
        " if s:hiType(group) != 0
        "     continue
        " endif
        " transBlendOpt is used to prevent hi from being clear
        execute('hi! ' . group . hiTerms)
    endfor

    " highlight cursorline number only
    " this needs option set cursorlineopt=number
    if s:hiType('CursorLineNr') == 0
        hi! CursorLineNr guibg=NONE ctermbg=NONE cterm=bold gui=bold
    endif

    for Func in s:themefixes
        call Func()
    endfor
endfunction

function! theme#Init()
    if has('termguicolors')
        set termguicolors
    endif

    if has('nvim')
        set fillchars+=stl:\ ,stlnc:\ ,
    endif

    let s:config = utils#merge(s:default_config, theme#loadConfig())

    let bg = s:config.background
    if utils#hascolorscheme(s:config[bg].theme)
        call theme#setColor(bg)
    else
        call theme#setColor(bg, s:config[bg].default)
    endif

    if s:config[bg].transparent
        call theme#enableTransparent()
    else
        call theme#disableTransparent()
    endif
    call s:generalThemeFix()

    if exists('*options#add')
        let toggle_transparent = { 'desc' : 'Toggle transparent background' }
        func toggle_transparent.togglefunc(...)
            call theme#toggleTransparent()
        endfunc
        call options#add('toggle_transparent', toggle_transparent)
    endif

    augroup GeneralTheme
        autocmd!
        autocmd ColorScheme * call s:generalThemeFix()
        autocmd ColorScheme * let s:config.background = &bg | call theme#setColor(&bg, expand('<amatch>'))
        autocmd VimLeave * call theme#saveConfig()
    augroup END

endfunction

function! theme#getConfig()
    return s:config
endfunction


if utils#hasplug('vim-illuminate') && g:vim_type == 'vim' " nvim doesn't need this config
    let g:Illuminate_highlightUnderCursor = 1
    let g:Illuminate_ftHighlightGroups = {
    \ 'vim:blacklist': ['vimLet', 'vimFuncKey', 'vimNotFunc', 'vimOperParen', 'vimLineComment'],
    \ 'java:blacklist' : [ 'javaType', 'javaScopeDecl', 'javaMethodDecl',
    \ 'javaComment', 'javaStorageClass', 'javaClassDecl', 'javaExternal',
    \ 'javaTypedef', 'javaLineComment', 'javaStatement', 'javaCommentTitle', 'javaDocComment' ],
    \ 'lua:blacklist' : [ 'luaComment', 'luaCond', 'luaStatement', 'luaFunction' ]
    \ }
    let g:Illuminate_ftwhitelist = ['vim', 'sh', 'python', 'rust', 'java',
        \ 'c', 'cpp', 'javascript', 'typescript', 'lua']

    " ugly workaround for the bug that illuminate not working after first enter vim
    " {
    function s:init_illuminate(...)
        let bgType = theme#getBgType()
        let bg = theme#getHiTerm('Visual', bgType)
        if bg != 'NONE' && &bg == 'dark'
            execute('hi illuminatedWord '.bgType.'='.bg)
            execute('hi illuminatedCurWord '.bgType.'='.bg)
        else
            hi illuminatedWord cterm=underline gui=underline
            hi illuminatedCurWord cterm=underline gui=underline
        end
    endfunction
    call RegisterLateInit(function('s:init_illuminate'), 0)
    " }

    augroup illuminate_augroup
        autocmd!
        autocmd ColorScheme * call s:init_illuminate()
    augroup END

endif

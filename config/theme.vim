
function! GetHi(group, term)
   " Store output of group to variable
   let output = execute('hi ' . a:group)
   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction

function! StrIsNr(input)
    if a:input =~# '^\d\+$'
        return v:true
    endif
    return v:false
endfunction

" Pick an appropriate 256 color base on old color
function! SuitableColor(oldColor)
    return a:oldColor - 40
endfunction

function! ThemeFix()
    let newValue = -1
    let hiGroups = ['CocErrorFloat', 'CocFloating', 'NormalFloat']
    if has('nvim')
        for group in hiGroups
            if hlexists(group)
                let oldColor = GetHi(group, 'ctermbg')
                if StrIsNr(oldColor)
                    let newValue = SuitableColor(str2nr(oldColor))
                    " execute('hi ' . group . ' ctermbg=' . newValue)
                    execute('autocmd! ColorScheme * hi ' . group . ' ctermbg=' . newValue)
                endif
            endif
        endfor
    end
endfunction

function! GetRidOfBg()
    let hiGroups = ['CocErrorSign', 'CocWarningSign', 'CocHintSign']
    for group in hiGroups
        if hlexists(group)
            execute('hi ' . group . ' ctermbg=none')
        endif
    endfor
endfunction

function! CocThemeFix()
    hi CocErrorHighlight cterm=underline ctermfg=124 ctermbg=none   " Keyword at the error position highlight
    hi CocErrorSign ctermbg=none ctermfg=124       " Error Sign at the sign column highlight 

    hi CocWarningSign ctermbg=none ctermfg=214     " Warning Sign at the sign column highlight 
    hi CocHintSign ctermbg=none ctermfg=214        " Hint Sign at the sign column highlight 
    hi CocUnusedHighlight cterm=underline ctermfg=214 ctermbg=none    " Unused variable/function etc. highlight
    hi CocWarningHighlight cterm=underline ctermfg=214 ctermbg=none    " Warning variable/function etc. highlight

    hi CocInfoHighlight ctermfg=207 ctermbg=none    " Info variable/function etc. highlight
    hi CocInfoSign ctermbg=none ctermfg=207        " Info Sign at the sign column highlight 

    hi Todo ctermbg=none ctermfg=214        " Info Sign at the sign column highlight 
    
    hi Error cterm=underline ctermfg=124 ctermbg=none
    hi javaError cterm=underline ctermfg=124 ctermbg=none

    highlight CursorLineNr ctermbg=none
    highlight SignColumn ctermbg=none
endfunction

call CocThemeFix()
au! ColorScheme * call CocThemeFix()

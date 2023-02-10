
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


if utils#hasplug('coc.nvim')
" let g:coc_global_extensions = ['coc-pyright', 'coc-tsserver', 'coc-vimlsp',
" \ 'coc-marksman']

" for tabline info
" coc-sumneko-lua offers autocomplete for neovim lua api
let g:coc_global_extensions = ['coc-nav', 'coc-sumneko-lua']

" warning that coc work best for vim >= 8.3
let g:coc_disable_startup_warning = 1

let g:coc_data_home = g:vim_dir . '/coc'
let g:coc_config_home = g:vim_dir . '/coc'

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

set updatetime=300

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction


" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <space>f  <Plug>(coc-format-selected)
nmap <space>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"COC LSP SETTING
let g:coc_user_config = {
\   'suggest.noselect': v:true,
\   'suggest.enablePreselect': v:false, }

call coc#config("java.jdt.ls.vmargs", '-javaagent:' . g:dotfiledir . '/config/coc/java/lombok-1.18.26.jar')
call coc#config("java.jdt.ls.lombokSupport.enabled", v:false)
call coc#config("java.inlayHints.parameterNames.enabled", v:false)
call coc#config("inlayHint.enable", v:false)

if has('nvim')
    " nvim has tree-sitter
    call coc#config("semanticTokens.enable", v:false)
else
    call coc#config("semanticTokens.enable", v:true)
endif

call coc#config("sumneko-lua.enableNvimLuaDev", v:true)

for section in ['suggest', 'diagnostic', 'signature', 'hover']
    call coc#config(section.'.floatConfig.border', v:true)
    call coc#config(section.'.floatConfig.rounded', v:true)
    call coc#config(section.'.floatConfig.highlight', 'Normal')

    " transparent setting (only for neovim)
    " call coc#config(section.'.floatConfig.winblend', 6)
endfor

function! CocHighlight()
    hi! CocErrorHighlight guifg=#E74C3C term=underline,bold gui=underline,bold cterm=underline,bold
    hi! CocErrorSign guifg=#E74C3C

    hi! CocWarningHighlight guifg=#E74C3C term=underline gui=underline cterm=underline
    hi! CocWarningSign guifg=#E67E22

    hi CocInfoHighlight term=underline gui=underline cterm=underline
    hi CocHintHighlight term=underline gui=underline cterm=underline
    hi CocUnusedHighlight term=underline gui=underline cterm=underline
endfunction

call theme#addCleanBg(['CocWarningSign', 'CocErrorSign'])

augroup CocHighlight
    autocmd!
    autocmd ColorScheme * call CocHighlight()
augroup END

function! Breadcrumbs()
    if ! exists('b:coc_nav')
        return ''
    endif
    let items = b:coc_nav
    " let t = '  '
    let t = ' '
    let c = 0
    for obj in items
        let hi = obj['highlight']
        let name = obj['name']
        if c == 0
            let t ..= '%#'.. hi ..'#' .. name .. '%#Normal#'
        else
            let t ..= '  %#'.. hi ..'#' .. name .. '%#Normal#'
        endif
        let c += 1
    endfor
    return t
endfunction

func! s:sigbar_enable()
    set tabline=%#Normal#🌠%{%Breadcrumbs()%}
    set showtabline=2
endfunc

func! s:sigbar_disable()
    set tabline=
    set showtabline=1
endfunc

" set tabline=%=%#Normal#%=%{%Breadcrumbs()%}
" set showtabline=2

let sigbar_opt = {
    \ 'desc': 'Show function signature bar',
    \ 'enablefunc': function('s:sigbar_enable'),
    \ 'disablefunc': function('s:sigbar_disable'),
    \ 'isEnabled': 0,
    \ }
call options#add('signature bar', sigbar_opt)

call theme#addTransGroup(['CocFloating'])

endif

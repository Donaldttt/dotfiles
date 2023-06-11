
if utils#hasplug("fzf") && utils#hasplug("fzf.vim")
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1
    "let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git \) -prune -o -print'

    "   - CTRL-/ will toggle preview window.
    let g:fzf_preview_window = ['right:50%']

    hi! fzfborderhi term=bold cterm=bold ctermbg=236 gui=bold guibg=#272c42
    hi! fzfqueryhi term=underline cterm=underline gui=underline

    let g:fzf_force_termguicolors = 1

    if g:os != 'Windows'
        let $FZF_DEFAULT_COMMAND = "find . -type f -not -path '*/\.git/*'"
    endif

    let s:preview_exe = expand(g:dotvimdir.'/bin/preview.py')
    let s:color_opts = ['--color', 'gutter:-1,bg+:-1,bg:-1,preview-bg:-1,preview-fg:-1,fg+:-1']

    " check if ripgrep is installed
    function! FzfRg()
        let s:previewcmd = join([utils#get_usable_py(), s:preview_exe, &bg, '{}'])
        if ! executable('rg')
            let cmd = 'grep -R --line-number --exclude-dir=".git;.svn" --color=always -- '.shellescape('')
        else
            let cmd = "rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape('')
        endif

        let options = s:color_opts + ['--border-label', 'Grep', '--border-label-pos', '9', '--no-scrollbar',
        \ '--no-hscroll', '--no-separator', '--preview', s:previewcmd]
        let with_preview = fzf#vim#with_preview()
        if len(with_preview) == 0
            let with_preview = {'options':['--preview-window','right:50%' ] + options}
        else
            " make fzf preview repect colorsheme
            let with_preview.options =  with_preview.options[:-3] + options
        endif
        call fzf#vim#grep(cmd, 1, with_preview, 0)
    endfunction

    function! FzfFiles(...)
        let s:previewcmd = join([utils#get_usable_py(), s:preview_exe, &bg, '{}'])
        let options = s:color_opts + ['--border-label', 'Files', '--border-label-pos', '9', '--no-scrollbar',
        \ '--no-hscroll', '--no-separator', '--preview', s:previewcmd]
        let with_preview = fzf#vim#with_preview()
        if len(with_preview) == 0
            " in windows with_preview return empty dict
            let with_preview = {'options':['--preview-window','right:50%' ] + options}
        else
            let with_preview.options =  with_preview.options[:-3] + options
        endif
        let dir = ''
        if a:0 >= 1 && isdirectory(expand(a:1))
            let dir = a:1
        endif
        call fzf#vim#files(dir, with_preview, 0)
    endfunction

    function! FzfColorSelect(color_name)
        call theme#setColor(&bg, a:color_name)
    endfunction

    function! FzfAirlineColorSelect(color_name)
        call theme#setStlColor(&background, a:color_name)
    endfunction

    let $FZF_DEFAULT_OPTS='--color=' . s:color_opts[1]

    function! FzfHelpTags()
        let s:previewcmd = join([utils#get_usable_py(), s:preview_exe, &bg, '{}'])
        let options = s:color_opts + ['--border-label', 'Files', '--border-label-pos', '9', '--no-scrollbar',
        \ '--no-hscroll', '--no-separator']
        let with_preview = fzf#vim#with_preview({ "placeholder": "--tag {2}:{3}:{4}" })
        if len(with_preview) == 0
            " in windows with_preview return empty dict
            let with_preview = {'options':['--preview-window','right:50%' ] + options}
        else
            let with_preview.options =  with_preview.options + options
        endif
        call fzf#vim#helptags(with_preview, 0)
    endfunction

    let s:optionmap = {}
    let s:feedfzf = []
    func! s:optioncb(str)
        call options#toggle(s:optionmap[a:str])
    endfunc
    func! FzfOptions()
        let s:feedfzf = []
        let s:optsource = options#getAll()
        for e in s:optsource
            let s:optionmap[e[1]] = e[0]
            call add(s:feedfzf, e[1])
        endfor
        call fzf#run(fzf#wrap({
                    \ 'source': s:feedfzf,
                    \ 'sink': function('s:optioncb'),
                    \ 'options': ['--border-label', 'Options'],
                    \ 'window': { 'width': 0.4, 'height': 0.6 }
                    \ }))
    endfunc

    " noremap <leader>fo :call FzfOptions()<CR>
    " noremap <leader>fr :call FzfRg()<CR>
    " noremap <leader>ff :call FzfFiles()<CR>
    noremap <leader>fh :call FzfHelpTags()<CR>
    " noremap <leader>fb :BLines<CR>
    noremap <leader>fu :call FzfFiles('~')<CR>

    if utils#hasplug('fzf-color-preview')
        let g:FzfColorComfirmCb = function('FzfColorSelect')
        let g:FzfAirlineComfirmCb = function('FzfAirlineColorSelect')
        noremap <leader>fa :AirlinePreview<CR>
        noremap <leader>fc :ColorsPreview<CR>
    else
        noremap <leader>fc :Colors<CR>
    endif
endif


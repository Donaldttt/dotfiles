
" giveup
if utils#hasplug('lightline.vim')
    set noshowmode
    set laststatus=2

    " enable bufferline
    " let g:bufferline_echo = 1

    let g:bufferline_inactive_highlight = 'Search'
    let g:bufferline_active_highlight = 'Search'
    let g:bufferline_forbided_col = 32

    let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode'],
      \             [ 'bufferline'] ],
      \   'right': [['lineinfo'], ['cocstatus']],
      \ },
      \ 'inactive': {
      \   'left': [],
      \   'right': [],
      \ },
      \ 'component_expand': {
      \     'bufferline': 'BufferlineStr',
      \ },
      \ 'component_function': {
      \   'cocstatus': 'AirlineCocStatus',
      \ },
      \ }


    function! s:restore()
        let g:lightline.active = {
              \   'left': [ [ 'mode'],
              \             [ 'bufferline'] ],
              \   'right': [['lineinfo'], ['cocstatus']],
              \ }
        call lightline#init()
        call lightline#update()
    endfunction

    let s:special_ft = ['nerdtree', 'vista']
    let s:special_bt = ['nofile']
    function! s:lightlineInit()
        let g:lightline.active = {
              \   'left': [],
              \   'right': [],
              \ }
        call lightline#init()
        call lightline#update()
        echom 'hello'. &bt
        autocmd WinLeave * ++once call s:restore()
    endfunction

        " \   'bufferline': 'lightline#bufferline#buffers'
    augroup Lightline
        autocmd!
        " autocmd BufWinEnter * call s:lightlineInit()
        " autocmd WinNew * call s:funck()
        autocmd FileType nerdtree call s:lightlineInit()
        " autocmd BufWritePost,TextChanged,TextChangedI,BufNew,BufEnter * call lightline#update()
    augroup END

    function! BufferlineStr()
        call bufferline#get_echo_string()
        let s = bufferline#get_status_string()
        return s
    endfunction

    function! s:lightline_update()
      if !exists('g:loaded_lightline')
        return
      endif
      try
        if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
          let g:lightline.colorscheme =
                \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
          call lightline#init()
          call lightline#colorscheme()
          call lightline#update()
        endif
      catch
      endtry
    endfunction

    augroup LightlineColorscheme
        autocmd!
        autocmd ColorScheme * call s:lightline_update()
    augroup END

    function! AirlineCocStatus()
        if ! exists('*CocAction')
            return
        endif
        let loading = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
        try
            let result = CocAction('services')
        catch
            " call timer_start(200, {->execute('AirlineRefresh')})
            return 'no coc '
        endtry
        let state = ''
        let id = ''
        for e in result
            if e['languageIds'][0] == &ft
                let state = e['state']
                let id = e['id']
            endif
        endfor
        if id == ''
            return 'no lsp '
        endif

        " messy way to get time in millisecond in vim
        let time = float2nr(str2float(reltime()->reltimestr()[4:]) * 1000)
        let speed = 800
        let loadidx = time % speed
        let msg = id
        if state == "starting"
            if ! exists('s:cocstatustimer') || len(timer_info(s:cocstatustimer)) == 0
                let s:cocstatustimer = timer_start(100, {->execute('AirlineRefresh')}, {'repeat': 800})
            endif
            return msg . " " . loading[loadidx/(speed/10)] . " "
        elseif state == "running"
            if exists('s:cocstatustimer')
                call timer_stop(s:cocstatustimer)
                unlet s:cocstatustimer
            endif
            return msg . " ✔ "
        endif
        return ''
    endfunction

endif

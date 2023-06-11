
if utils#hasplug("vim-airline")

    " Extensions
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

    function! AirlineBufferNumber()
        return len(g:index_to_buffer)
    endfunction

    " This must use my fork version of bufferline
    " the number of cols bufferline cannot use out of max of screen cols
    let g:bufferline_forbided_col = 32

    let g:airline_experimental = g:vim_v >= 900 ? 1 : 0

    function! AirlineInit()
        " call airline#parts#define_function('bufnum', 'AirlineBufferNumber')
        call airline#parts#define_function('cocstatus', 'AirlineCocStatus')
        call airline#parts#define_minwidth('mode', 10)
        let _airline_section_y = ''
        if utils#hasplug('coc.nvim')
            " let _airline_section_y = airline#section#create(['cocstatus'])
        endif
        let g:airline_section_a       = airline#section#create(['mode'])
        let g:airline_section_b       = ''
        let g:airline_section_error   = ''
        let g:airline_section_warning = ''
        " let g:airline_section_x       = airline#section#create(['bufnum'])
        let g:airline_section_x       = ''
        let g:airline_section_y       = _airline_section_y
        let g:airline_section_z       = airline#section#create(['cocstatus', '│ ', '%(%l:%c%)'])

    endfunction

    function! AirlineColouriseSplits()
        " get rid of the vertical split between two windows in statusline
        hi! link StatusLine airline_z
        hi! link StatusLineNC airline_z_inactive
    endfunction

    augroup AirlineAu
        autocmd!
        autocmd ColorScheme * call AirlineColouriseSplits()
        autocmd User AirlineAfterInit ++once call AirlineInit()
    augroup end

    " let g:airline_left_sep = ''
    " let g:airline_left_alt_sep = ''
    " let g:airline_right_sep = ''
    " let g:airline_right_alt_sep = ''

    function s:airline_refresh(...)
        " this has to be set late otherwise it will cause 'mode' extension be
        " skipped at startup
        let g:airline_skip_empty_sections = 1
    endfunction
    call RegisterLateInit(function('s:airline_refresh'), 1)

    " let g:airline_skip_empty_sections = 1

    let g:airline_inactive_collapse = 1
    let g:airline_focuslost_inactive = 0
    let g:airline_extensions = ['bufferline']

    let g:airline_filetype_overrides = {
        \ 'vista':  ['Vista', ''],
        \ 'minimap':  ['', ''],
        \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), ''],
        \ }

    " hide airline in startify
    function! HideStartify(...)
        let ctx = a:2
        if ! ctx.active
            return 1
        end
        if &filetype == 'startify'
            let builder = a:1
            call builder.add_section('Normal', '')
            return 1
        endif
        if &filetype == 'help'
            let builder = a:1
            call builder.add_section('airline_a_bold', ' Help ')
            call builder.add_section('airline_c', ' %f')
            return 1
        endif

    endfunction
    call airline#add_statusline_func('HideStartify')

    " " without this airline will overwrite some setting like bufferline_active_buffer_left, etc.
    let g:airline#extensions#bufferline#overwrite_variables = 0
    " call theme#addTransGroup(['airline_c', 'airline_c_bold'])
    " let g:airline_mode_map = {
    "     \ '__'     : '-',
    "     \ 'c'      : 'C',
    "     \ 'i'      : 'I',
    "     \ 'ic'     : 'I',
    "     \ 'ix'     : 'I',
    "     \ 'n'      : 'N',
    "     \ 'multi'  : 'M',
    "     \ 'ni'     : 'N',
    "     \ 'no'     : 'N',
    "     \ 'R'      : 'R',
    "     \ 'Rv'     : 'R',
    "     \ 's'      : 'S',
    "     \ 'S'      : 'S',
    "     \ ''     : 'S',
    "     \ 't'      : 'T',
    "     \ 'v'      : 'V',
    "     \ 'V'      : 'V',
    "     \ ''     : 'V',
    "     \ }

endif


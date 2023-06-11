vim9script

if utils#hasplug('vim-global-statusline')

    g:stl_nonbtbg = 'folded'
    g:stl_bg = 'normal'
    g:bufferline_forbided_col = 32

    def ReverseHl(name: string, hl: string)
        var hl_terms = theme#getHiTerms(hl)
        var normal_terms = theme#getHiTerms('normal')
        for [term, val] in items(hl_terms)
            if val == 'NONE'
                hl_terms[term] = normal_terms[term]
            endif
        endfor
        exe 'hi ' .. name .. ' guibg=' .. hl_terms['guifg'] .. ' guifg='
        .. hl_terms['guibg'] .. ' ctermbg=' .. hl_terms['ctermfg']
        .. ' ctermfg=' .. hl_terms['ctermbg']
    enddef

    def StlHighlight()
        hi normalModeGstl cterm=reverse gui=reverse
        ReverseHl('insertModeGstl', 'function')
        ReverseHl('visualModeGstl', 'statement')
        ReverseHl('commandModeGstl', 'number')
    enddef
    autocmd ColorScheme * StlHighlight()
    var mode_color = {
        n: 'normalModeGstl',
        i: 'insertModeGstl',
        v: 'visualModeGstl',
        V: 'visualModeGstl',
        c: 'commandModeGstl',
        }
    var mode_str = {
        n: ' NORMAL  ',
        i: ' INSERT  ',
        v: ' VISUAL  ',
        V: ' V-LINE  ',
        c: ' COMMAND ',
        }
    mode_str[nr2char(22)] = ' V-BLOCK '
    mode_color[nr2char(22)] = 'curSearch'
    def Modestr(): void
        var m = mode()
        if has_key(mode_str, m)
            g:StlSetPart(0, mode_str[m], mode_color[m], 'mode')
        else
            echom char2nr(m)
            g:StlSetPart(0, ' ' .. &ft .. ' ', 'TabLineSel', 'mode')
        endif
        g:StlRefresh()
    enddef

    def Fnstr(): void
        g:StlSetPart(10, 'filename: ' .. bufname(), '', 'filename')
        g:StlRefresh()
    enddef

    def Bufstr(): void
        var bufstr = bufferline#get_echo_string()
        g:StlSetPart(9, ' ' .. bufstr, '', 'bufstr')
        g:StlRefresh()
    enddef

    def Lncol(): void
        var col = virtcol(".")
        var ln = line('.')
        var m = mode()
        var color = ''
        if has_key(mode_color, m)
            color = mode_color[m]
        else
            color = 'TabLineSel'
        endif
        g:StlSetPart(&co - 9, printf("  %d:%d", ln, col), color, 'linenr')
        g:StlRefresh()
    enddef

    var cocstatustimer = -1

    def Cocstatus(): string
        const loading = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
        var results = []
        var result = '𐄂'
        var fticon = '𐄂'
        try
            if exists('g:CocAction')
                results = g:CocAction('services')
            endif
        catch
        endtry
        var state = ''
        var id = ''
        if len(results) == 0
            timer_start(100, function(Lsp))
        endif
        for e in results
            if e['languageIds'][0] == &ft
                state = e['state']
                id = e['id']
            endif
        endfor

        # messy way to get time in millisecond in vim
        var time = float2nr(str2float(reltime()->reltimestr()[4 : ]) * 1000)
        var speed = 800
        var loadidx = time % speed
        var msg = id
        if state == "starting"
            if len(timer_info(cocstatustimer)) == 0
                cocstatustimer = timer_start(100, function(Lsp), {'repeat': 800})
            endif
            fticon = loading[loadidx / (speed / 10)]
        elseif state == "running"
            if len(timer_info(cocstatustimer)) != 0
                timer_stop(cocstatustimer)
                cocstatustimer = -1
            endif
            if exists('g:WebDevIconsGetFileTypeSymbol')
                fticon = g:WebDevIconsGetFileTypeSymbol()
            endif
        endif
        # return fticon .. '  ' .. result
        return 'lsp ' .. fticon
    enddef

    def Lsp(...timer: list<any>): void
        var s = Cocstatus()
        g:StlSetPart(&co - 17, ' ' .. s .. ' ', '', 'lsp')
        g:StlRefresh()
    enddef

    var fancytimer = 0 
    def Fancy(...timer: list<any>): void
        var expressions = [' (◕_◕)', ' (◕‿◕)', '\(◕◡◕\)', ' (◣_◢)', ' (◣‿◢)', '\(◣◡◣\)', ' (◠‿◠)', ' (◠_◠)', '\(◠◡◠\)', ' (◡‿◡)', ' (◡_◡)', '\(◡◡◡\)', ' (┳Д┳)', ' (个_个)', ' ( ≧Д≦)', ' 흫_흫', ' 句_句']

        # var letters = [𝔞 𝔟 𝔠 𝔡 𝔢 𝔣 𝔤 𝔥 𝔦 𝔧 𝔨 𝔩 𝔪 𝔫 𝔬 𝔭 𝔮 𝔯 𝔰 𝔱 𝔲 𝔳 𝔴 𝔵 𝔶 𝔷]

        # string "I love you" using unicode letters
        var lang = ''
        if &ft == 'python'
            lang = '𝕻𝖞𝖙𝖍𝖔𝖓'
        elseif &ft == 'java'
            lang = '𝕵𝖆𝖛𝖆'
        elseif &ft == 'javascript'
            lang = '𝕵𝖆𝖛𝖆𝖘𝖈𝖗𝖎𝖕𝖙'
        elseif &ft == 'lua'
            lang = '𝕷𝖚𝖆'
        elseif &ft == 'vim'
            lang = '𝓥𝓲𝓶 𝓢𝓬𝓻𝓲𝓹𝓽'
        else
            lang = &ft
        endif
        var str = lang ..  ' 𝔦𝔰 𝔱𝔥𝔢 𝔟𝔢𝔰𝔱 𝔩𝔞𝔫𝔤𝔲𝔞𝔤𝔢'

        # fancytimer = (fancytimer + 1) % len(str) 
        g:StlSetPart(&co - 27 - strcharlen(str), str, '', 'fancy')
    enddef

    def Theme(): void
        # const light = '☀'
        # const dark = '☽'
        const light = '🌕'
        const dark = '🌑'
        var theme = &bg == 'light' ? light : dark
        g:StlSetPart(&co - 23, '│ ' .. theme, '', 'bgc')
        g:StlRefresh()
    enddef

    def EnterInit(): void
        # Theme()
        Lncol()
        Lsp()
        # autocmd GlobalStl ColorScheme  * Theme()
    enddef

    augroup GlobalStl
        autocmd!
        autocmd VimEnter,ModeChanged * Modestr() | Lncol()
        autocmd BufEnter,BufDelete,BufWritePost * Bufstr() | Modestr()
        autocmd CursorHold * Lncol()
        autocmd BufEnter,BufReadPost  * Lsp()
        autocmd VimEnter * EnterInit()
    augroup END

endif

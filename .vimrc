" Modeline and Notes {
" Environment {
    " get current neovim version
    let g:vim_version = -1

    " dotfile location
    let g:mydotfiles_directory = expand('~/.dotfiles/')
    let after_directory = g:mydotfiles_directory . 'config/vi-plugs/coc-theme/after/'
    if has('nvim')
        let g:vim_type = 'nvim'
        let g:vim_version = matchstr(execute('version'), 'NVIM v\zs[^\n]*')
    else
        let g:vim_type = 'vim'
        let g:vim_version = matchstr(execute('version'), 'Vi IMproved \zs[^\n]*')
    endif
    let g:vim_version = str2float(g:vim_version)
    let g:dotfile_path = '~/.dotfiles/'

    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    execute('set runtimepath^=' . after_directory)
    let &packpath=&runtimepath

    " The default leader is '\', but many people prefer ',' as it's in a standard
    let mapleader = ','
    let maplocalleader = '_'

" }

" General {

    noremap <leader>h :noh<CR>  " turn off highlight

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    "set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8


    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened;
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    " Always switch to the current file directory

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    " set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator
    "set iskeyword-=_                    " '_' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
    " }

" }

" Vim UI {
"
    " set tabpagemax=15               " Only show 15 tabs
    " set showmode                    " Display the current mode
    " set cursorline                    " Highlight current line

    " get rid of current line highlight, instead just highlight the number column
    augroup CLClear
        autocmd! ColorScheme * hi clear CursorLine
    augroup END

    set cmdheight=1                 " get rid of the extra useless line at the bottom(if not working, probably a plugin is changing the value)

    "highlight clear SignColumn      " SignColumn should match background
    "highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and

    endif

    set backspace=indent,eol,start  " Backspace for dummies

    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=1                " Lines to scroll when cursor leaves screen
    set scrolloff=5                 " Minimum lines to keep above and below cursor
    set sidescrolloff=5            " Minimum lines to keep at the left or right of the cursor


" }

" Formatting {

    "set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set nolist                      " let vim not showing '$' or other sign
    "set list                        " Display unprintable characters f12 - switches
    "set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping
    set nospell                     " Spell checking off

    set matchpairs+=<:>             " Match, to be used with %
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }

" Key (re)Mappings {

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Stupid shift key fixes
    " if !exists('g:spf13_no_keyfixes')
    "     if has("user_commands")
    "         command! -bang -nargs=* -complete=file E e<bang> <args>
    "         command! -bang -nargs=* -complete=file W w<bang> <args>
    "         command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    "         command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    "         command! -bang Wa wa<bang>
    "         command! -bang WA wa<bang>
    "         command! -bang Q q<bang>
    "         command! -bang QA qa<bang>
    "         command! -bang Qa qa<bang>
    "     endif

    "     cmap Tabe tabe
    " endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    if has('nvim')
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
    else
        set foldmethod=syntax
        autocmd FileType python set foldmethod=indent
    endif

    " so when a buffer open it wouldn't be fold by default
    set nofoldenable

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>j [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    " nnoremap <silent> <leader>q gwip

" Functions {

    " Initialize directories for undo, swap, viewdir
    " to ~/.vim/.vim*
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        let g:spf13_consolidated_directory = $HOME . '/.vim/.'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()

    " Shell command 
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
     
" Fix file type error for typescript
    autocmd BufNewFile,BufRead *.ts set filetype=typescript


"  These are to cancel the default behavior of d, D, c, C
"  to put the text they delete in the default register.
"  Note that this means e.g. "ad won't copy the text into
"  register a anymore.  You have to explicitly yank it.
"  TIPS: you can type :registers to view value in each registers
    vnoremap p "0p


"   TIPS: :hi can be used to check current highlight options
"   Coc has wired floating color, this is an attempt to fix it
"    highlight CocFloating ctermbg=green
"    highlight FgCocErrorFloatBgCocFloating cterm=bold ctermfg=124 guifg=DarkRed ctermbg=green

"   c highlight fix
"    highlight cComment ctermfg=12 guifg=#458588

"   copy to system
    set clipboard=unnamed

"   fix paste mess up when using tmux
    if &term =~ "screen"
        let &t_BE = "\e[?2004h"  
        let &t_BD = "\e[?2004l" 
        exec "set t_PS=\e[200~" 
        exec "set t_PE=\e[201~"
    endif

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }


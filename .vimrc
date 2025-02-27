    " dotfile location
    let g:dotfiledir = expand(fnamemodify(resolve(expand('<sfile>:p')), ':h').'/')
    " vim runtime folder
    let g:vim_dir = expand('~/.vim/')

    " detect vim type(vim or nvim)
    let g:vim_v = 0
    if has('nvim')
        let g:vim_type = 'nvim'
    else
        let g:vim_type = 'vim'
        let g:vim_v = v:version
    endif

    " detect operating system (Windows/Linux/Darwin)
    let g:isWSL = 0
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
        set updatetime=50
        if executable('pwsh')
            " prefer to use powershell 7
            set shell=pwsh
        else
            set shell=powershell
        endif
    else
        let g:os = substitute(system('uname'), '\n', '', '')
        if system('uname -r') =~ "icrosoft"
            let g:isWSL = 1
        endif
    endif


    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath=&runtimepath

    " The default leader is '\', but many people prefer ',' as it's in a standard
    let mapleader = ','
    let maplocalleader = '_'

" General {

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set belloff=all             " Turn off the annoying bell
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    set shortmess+=F            " Don't show the file name when open new file
    " scriptencoding utf-8

    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    " set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    " set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword+=-

    augroup FileFormat
        autocmd!
        autocmd FileType javascript,typescript,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
        " autocmd FileType c,cpp,python,java setlocal tabstop=4 shiftwidth=4 softtabstop=4
        autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
        autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
        " Instead of reverting the cursor to the last position in the buffer, we
        " set it to the first line when editing a git commit message
        autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END

    " Setting up the directories {
        " set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
    " }

" }

" Vim UI {
"
    set noshowmode
    set cursorline                  " Highlight current line
    set cursorlineopt=number        " only highlight line number
    set cmdheight=1                 " get rid of the extra useless line at the bottom(if not working, probably a plugin is changing the value)

    set backspace=indent,eol,start  " Backspace for dummies
    set fillchars=eob:\ ,vert:│,stl:\ ,stlnc:\ ,   " it can remove '~' at the end of buffer, and window split line
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
    set sidescrolloff=5             " Minimum lines to keep at the left or right of the cursor
    set display=lastline            " don't replace whole long line with @@@
    augroup cc
        au!
        autocmd FileType c,cpp,vim,java,python,lua set colorcolumn=80
        autocmd FileType help set colorcolumn=
    augroup END

" }

" Formatting {
    set autoindent                  " Indent at the same level of the previous line
    set expandtab                   " Tabs are spaces, not tabs
    set shiftwidth=4                " Use indents of 4 spaces
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent

    set conceallevel=0
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    " set nolist                      " let vim not showing '$' or other sign
    set list                        " Display unprintable characters f12 - switches

    " stop inserting the current comment leader after hitting 'o' or 'O' in Normal mode
    au FileType * setlocal formatoptions-=o

    set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping

    set nospell                     " Spell checking off
    set matchpairs+=<:>             " Match, to be used with %

" }

" Key (re)Mappings {

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    set foldmethod=syntax
    augroup vimfold
        autocmd!
        if has('nvim')
            " check tree-sitter config
        else
            autocmd FileType python set foldmethod=indent
            autocmd FileType vim set foldmethod=syntax
        endif
    augroup END

    " so when a buffer open it wouldn't be fold by default
    " set nofoldenable
    set foldlevelstart=99

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    " cmap w!! w !sudo tee % >/dev/null

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>j [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

" Functions {

    " Initialize directories for undo, swap, viewdir (see :h undodir, etc.)
    " to ~/.vim/.vim*
    function! InitializeDirectories()
        let common_dir = g:vim_dir
        let dir_list = {
                    \ 'backupdir' : '.vimbackup',
                    \ 'viewdir' : '.vimviews',
                    \ 'directory' : '.vimswap' }

        if has('persistent_undo')
            let dir_list['undodir'] = '.vimundo'
        endif

        for [settingname, dirname] in items(dir_list)
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

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
    vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
    vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Fix file type error for typescript
    autocmd BufNewFile,BufRead *.ts set filetype=typescript

"   copy to system
    if g:os == 'Darwin' || g:os == 'Windows'
        set clipboard=unnamed
    else
        if g:isWSL && has('nvim')
            " :h clipboard-wsl
            set clipboard=unnamedplus

            " cache has to be enabled otherwise cause freeze
            " obviously wsl without xclip won't work
            let g:clipboard = {
                \   'name': 'WSLxclip',
                \   'copy': {
                \      '+': 'xclip -quiet -i -selection clipboard',
                \      '*': 'xclip -quiet -i -selection primary',
                \    },
                \   'paste': {
                \      '+': 'xclip -o -selection clipboard',
                \      '*': 'xclip -o -selection primary',
                \   },
                \   'cache_enabled': 1,
                \ }
        elseif g:isWSL
            set clipboard=unnamedplus
        else
            set clipboard=unnamedplus
        endif
    endif

"   fix paste mess up when using tmux
    if &term =~ "screen"
        let &t_BE = "\e[?2004h"
        let &t_BD = "\e[?2004l"
        exec "set t_PS=\e[200~"
        exec "set t_PE=\e[201~"
    endif

" disable netrw as i am using nerdtree and nvim-tree
let  g:loaded_netrw = 1
let  g:loaded_netrwPlugin = 1

" Use bundles config {
    if filereadable(g:dotfiledir."/main.vim")
        execute('source '.g:dotfiledir.'/main.vim')
    endif
" }

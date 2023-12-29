" (jump to the topic)
"
" OPTIONS
" PLUGIN_INSTALL
" UTILITIES
" PLUGIN_CONFIGURATION " THEME_CONFIGURATION
" KEY_MAPS
" OTHER_CONFIGS

let g:high_performence = v:false
let g:autocomplte_enable = v:true
let g:copilot_enable = v:true

" only in nvim (using which-key)
let g:key_prompt = v:false

" only used by neovim
let g:classic_vim_ui = v:true
let g:animation_enable = v:false

let g:swap_dict = [
    \ ['v:false', '0', 'dark', 'false' ],
    \ ['v:true' , '1', 'light', 'true']]
" convinient function to swap between two options
nmap <leader><leader>t :call utils#swapword()<CR>

"""""" PLUGIN_INSTALL """"""

let g:dotvimdir = expand(g:dotfiledir . 'config/vim/')
let g:plugin_dir = expand(g:vim_dir . 'plugged/')

let g:theme_config_path = expand(g:vim_dir . ".config.vim")

call plug#begin(g:plugin_dir)
    " https://github.com/junegunn/vim-plug/wiki/tips
    function! Cond(cond, ...)
      let opts = get(a:000, 0, {})
      return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
    endfunction
    let g:animation_enable = g:high_performence ? v:false : g:animation_enable

    if !g:high_performence
        Plug 'aditya-azad/candle-grey'
        Plug 't184256/vim-boring'
        Plug 'tek256/simple-dark'
        Plug 'sainnhe/everforest'
        Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
        Plug 'cocopon/iceberg.vim'
        Plug 'catppuccin/nvim', Cond( has('nvim-0.8.2')  \|\| g:vim_v >= 900  , { 'as': 'catppuccin' })
        Plug 'NLKNguyen/papercolor-theme'
        Plug 'EdenEast/nightfox.nvim', Cond(has('nvim-0.5'))
        Plug 'projekt0n/github-nvim-theme', Cond(has('nvim-0.5'), { 'tag': 'v0.0.7' })
        Plug 'folke/tokyonight.nvim', Cond(g:vim_type == 'nvim', { 'branch': 'main' })
        Plug 'andymass/vim-matchup'
    endif
    Plug 'Donaldttt/fuzzyy'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    " Plug 'lervag/vimtex'
    Plug 'github/copilot.vim', Cond(( g:vim_type == 'nvim' \|\| g:vim_v >= 900 )
        \ && g:copilot_enable && executable('node'))

    Plug 'nanotee/zoxide.vim', Cond(executable('zoxide'))

    Plug 'godlygeek/tabular'

    Plug 'preservim/vim-markdown'

    Plug 'dstein64/vim-startuptime', Cond(!g:high_performence)
    Plug 'simeji/winresizer', Cond(!g:high_performence)
    " Plug 'rust-lang/rust.vim', { 'for': ['rust'] }

    Plug 'rhysd/conflict-marker.vim'

    Plug 'jiangmiao/auto-pairs'
    " Plug 'mg979/vim-visual-multi'
    Plug 'RRethy/vim-illuminate', Cond(!g:high_performence)
    " Plug 'ludovicchabant/vim-gutentags'
    " Plug 'ctrlpvim/ctrlp.vim'

    "" ESSENTIAL_PLUGINS ""

    Plug 'mhinz/vim-startify'
    Plug 'christoomey/vim-tmux-navigator'
    " Comment stuff out
    Plug 'tpope/vim-commentary'
    Plug 'vim-scripts/restore_view.vim'

    " vim only plugins
    Plug 'scrooloose/nerdtree', Cond(g:vim_type == 'vim' \|\| !has('nvim-0.8'), { 'on' : ['NERDTreeToggle', 'NERDTreeFind'] })
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight', Cond(g:vim_type == 'vim' && !g:high_performence)

    Plug 'neoclide/coc.nvim', Cond(g:autocomplte_enable && executable('node'), {'branch': 'release'})
    " only work with vim
    if g:vim_type == 'vim'
        if executable('ctags')
            Plug 'preservim/tagbar'
        else
            Plug 'liuchengxu/vista.vim', Cond(!g:high_performence)
        endif

        Plug 'airblade/vim-rooter'
        " Plug 'justinmk/vim-sneak'
        Plug 'airblade/vim-gitgutter'
        Plug 'chriskempson/base16-vim'
        " Plug 'Yggdroot/indentLine'
        " Plug 'Donaldttt/fzf-color-preview', Cond(g:vim_v >= 800, { 'on': ['ColorsPreview', 'AirlinePreview'] })

        Plug 'markonm/traces.vim'
        Plug 'voldikss/vim-floaterm', Cond(has('terminal') && g:vim_type == 'vim')
        set encoding=UTF-8
        " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        " Plug 'junegunn/fzf.vim'
        " Plug 'antoinemadec/coc-fzf', Cond(g:os != 'Windows', {'on': ['CocFzfList']})

        Plug 'Donaldttt/vim-bufferline'

        Plug 'Donaldttt/vim-global-statusline', { 'branch': 'vim9' }
        " Plug 'vim-airline/vim-airline'
        " Plug 'vim-airline/vim-airline-themes'

        Plug 'ryanoasis/vim-devicons'
        " Plug 'wfxr/minimap.vim', Cond(executable('code-minimap'), {'on' : ['MinimapToggle']})
    endif

    if g:vim_type == 'nvim'
        Plug 'RRethy/nvim-base16'

        if has('nvim-0.5')
            " Plug 'hkupty/iron.nvim'
            " Plug 'metakirby5/codi.vim'
            Plug 'lukas-reineke/indent-blankline.nvim', Cond(!g:animation_enable)
            Plug 'echasnovski/mini.indentscope', Cond(g:animation_enable)
            Plug 'echasnovski/mini.animate', Cond(g:animation_enable)

            Plug 'nvim-lualine/lualine.nvim'
            Plug 'petertriho/nvim-scrollbar', Cond(g:animation_enable)
            Plug 'folke/which-key.nvim', Cond(!g:high_performence && g:key_prompt)
            Plug 'ahmedkhalf/project.nvim'
        endif
        if has('nvim-0.7')
            Plug 'stevearc/aerial.nvim'
            Plug 'nvim-treesitter/nvim-treesitter', Cond(executable('make'), {'do': ':TSUpdate'})

            " for telescope
            Plug 'nvim-lua/plenary.nvim'
            Plug 'nvim-telescope/telescope.nvim', Cond(g:vim_type == 'nvim', { 'branch': '0.1.x' })
            " c plugin for telescope to make it faster
            Plug 'nvim-telescope/telescope-fzf-native.nvim', Cond(executable('make'), { 'do': 'make' })

            " comment out this plugin if the machine doesn't have required
            " font install
            Plug 'nvim-tree/nvim-web-devicons'
            Plug 'akinsho/toggleterm.nvim', Cond(g:vim_type == 'nvim', {'tag' : '*'})

            Plug 'ggandor/leap.nvim'
        endif
        if has('nvim-0.8')
            Plug 'nvim-tree/nvim-tree.lua'
            Plug 'lewis6991/gitsigns.nvim'

            Plug 'rcarriga/nvim-notify', Cond(!g:high_performence && !g:classic_vim_ui)
            Plug 'folke/noice.nvim', Cond(!g:high_performence && !g:classic_vim_ui)
            Plug 'MunifTanjim/nui.nvim', Cond(!g:high_performence && !g:classic_vim_ui)
        endif

        " nvim theme
        if has('nvim-0.9')
            Plug 'rebelot/kanagawa.nvim'
            Plug 'rose-pine/neovim', { 'as': 'rose-pine' }
        endif
    endif

    " custom plugin
    Plug g:dotvimdir
call plug#end()

augroup InitConfig
    " Automatically install missing plugins at startup
    autocmd VimEnter *
        \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall --sync | q
        \| endif
augroup end

"""""" UTILITIES """"""

" a list of funcref that will be initilized late
let g:post_init_func = []

function RegisterLateInit(func, delay, ...)
    let Funcref = type(a:func) == 10 ? func : function(a:func)
    let obj = [Funcref, a:delay, a:000]
    call add(g:post_init_func, obj)
endfunction

function s:executeLateInit()
    function s:lateInitHelper(...)
        for obj in g:post_init_func
            let Funcref = obj[0]
            let delay = obj[1]
            let args = obj[2]
            if delay == 0
                if len(args) > 0
                    call Funcref(args)
                else
                    call Funcref()
                endif
            else
                call timer_start(delay, Funcref)
            endif
        endfor
    endfunction
    autocmd VimEnter * call s:lateInitHelper()
endfunction

" source all vim specific config eg. gui vim
for f in split(glob(g:dotvimdir.'/configs/*-config.vim'), '\n')
    exe 'source' f
endfor

" source all vim plugin config
for f in split(glob(g:dotvimdir.'/vim-plugin-settings/*.config.vim'), '\n')
    exe 'source' f
endfor

" source all vim9 plugin configs
if g:vim_v >= 900
for f in split(glob(g:dotvimdir.'/vim-plugin-settings/vim9/*.config.vim'), '\n')
    exe 'source' f
endfor
endif

" source lua plugins if in neovim
if has('nvim')
    lua require('lua-plugin-settings')
endif

" source lua library

"""""" THEME_CONFIGURATION """"""
nmap <Leader>db :call utils#showHiGroup()<CR>

    """ THEME_OPTIONS """

call theme#Init()

"""""" KEY_MAPS """"""
" (This doesn't include plugin specific mapping.
" For them  check plugin Preferences)

nnoremap <leader>ws :call utils#trimwhitespace()<CR>

" Toggle dark/light theme
noremap <silent> <leader>cbg :call theme#toggleBg()<CR>

" Toggle transparent background
noremap <silent> <leader>ctb :call theme#toggleTransparent()<CR>

" Buffer navigation
nnoremap <silent> <space>q :bprevious<CR>
nnoremap <silent> <space>e :bnext<CR>

" leader s change all occurence
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>

noremap <leader>h :noh<CR>  " turn off highlight

" disable two easily mispressed yet useless key
nnoremap q: <nop>
nnoremap Q <nop>

" we often press shift key by mistake
command WQ wq
command Wq wq
command W w
command Q q

" leader num change tab
" only for vim or nvim without lualine

if (g:vim_type == 'vim' || !has('nvim-0.5')) && utils#hasplug('vim-bufferline')
    for i in range(1, 9)
        execute "nnoremap <silent> <nowait> <leader>" . i .
            \ " :call bufferline#jump(" . i . ")<CR>"
    endfor
    for i in range(10, 20)
        execute "nnoremap <silent> <nowait> <leader><leader>" . i .
            \ " :call bufferline#jump(" . i . ")<CR>"
    endfor
end

" split window comform with other window management shortcuts
nnoremap <silent> <C-w>% :vsplit<CR>
nnoremap <silent> <C-w>" :split<CR>

call s:executeLateInit()

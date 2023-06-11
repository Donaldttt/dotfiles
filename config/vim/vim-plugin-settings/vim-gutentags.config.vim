
if utils#hasplug("vim-gutentags")
    if exists("*gutentags#statusline()")
        set statusline+=%{gutentags#statusline()}
    endif
    let g:gutentags_trace = 1
    let g:gutentags_cache_dir=g:vim_dir . '/.vimtags/'
    let g:gutentags_project_root=['.git', '.hg', '.svn', '.bzr', '_darcs', '_FOSSIL_', '.fslckout', 'src']
endif


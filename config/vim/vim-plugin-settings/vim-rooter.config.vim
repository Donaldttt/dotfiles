
if utils#hasplug("vim-rooter")
    let g:rooter_patterns = ['.vscode', '.git', '*.sln', 'src']
    let g:rooter_change_directory_for_non_project_files = ''
    let g:rooter_silent_chdir = 0
    " let g:rooter_manual_only = 1
endif


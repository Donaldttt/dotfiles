vim9script

if utils#hasplug('fuzzyy')
    g:files_respect_gitignore = 1
    g:fuzzyy_menu_matched_hl = 'error'
    g:fuzzyy_dropdown = 1
endif

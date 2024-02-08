vim9script

if utils#hasplug('fuzzyy')
    g:files_respect_gitignore = 1
    g:fuzzyy_menu_matched_hl = 'error'
    g:fuzzyy_dropdown = 1
    g:enable_fuzzyy_MRU_files = 1
    g:fuzzyy_window_layout = {
        FuzzyFiles: {
            width: 0.8,
        },
        FuzzyMRUFiles: {
            preview: 1,
        },
        FuzzyBuffers: {
            preview: 1,
            width: 0.8,
            preview_ratio: 0.5,
        },
        FuzzyGrep: {
            preview: 1,
            width: 0.8,
            preview_ratio: 0.5,
        },
    }
endif

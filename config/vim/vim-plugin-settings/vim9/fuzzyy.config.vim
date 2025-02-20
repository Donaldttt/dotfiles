vim9script

highlight link fuzzyyMatching error
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
g:fuzzyy_buffers_keymap = {
'delete_buffer': "\<c-g>",
'close_buffer': "\<c-l>",
}
nnoremap <silent> <leader>fl :FuzzyCmdHistory<CR>

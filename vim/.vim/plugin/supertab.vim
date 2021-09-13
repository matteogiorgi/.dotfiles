let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabContextDefaultCompletionType = '<c-n>'
let g:SuperTabMappingForward = '<tab>'
let g:SuperTabMappingBackward = '<S-tab>'

" Remap <CR> to inserte selection
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

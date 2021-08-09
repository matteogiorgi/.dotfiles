" normal comment -> gcc
" visual commant -> gcc

augroup personalcomments
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    autocmd FileType json,jsonc setlocal commentstring=//\ %s
augroup end

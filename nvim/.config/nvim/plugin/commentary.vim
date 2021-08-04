" Maps
nmap <silent><leader><space> gcc<CR>
vmap <silent><leader><space> gc<CR>


augroup personalcomments
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    autocmd FileType json,jsonc setlocal commentstring=//\ %s
augroup end

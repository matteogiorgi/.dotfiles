nmap <silent><leader><space> gcc
vmap <silent><leader><space> gc

augroup personalcomments
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    autocmd FileType json,jsonc setlocal commentstring=//\ %s
    autocmd FileType toml setlocal commentstring=#\ %s
    autocmd FileType markdown,markdown.pandoc,pandoc setlocal commentstring=<!--\ %s\ -->
augroup end

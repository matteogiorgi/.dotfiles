setlocal wrap
setlocal conceallevel=2


nmap <buffer> <leader>n <Plug>(NoteWiki)
nmap <buffer> <leader>N <Plug>(NoteBrowse)<cr>
nmap <buffer> <leader>p <Plug>(NotePandoc)<cr>

nmap <buffer> <tab> <Plug>(NextLink)
nmap <buffer> <S-tab> <Plug>(PrevLink)
nmap <buffer> <backspace> <Plug>(Back)
nmap <buffer> <return> <Plug>(OpenLink)
nmap <buffer> \ <Plug>(EndPar)

nnoremap <buffer> - :HeaderIncrease<cr>
nnoremap <buffer> _ :HeaderDecrease<cr>

noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj

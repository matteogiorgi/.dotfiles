setlocal wrap
setlocal conceallevel=2


nmap <buffer> <leader>ni  <Plug>(NoteWiki)
nmap <buffer> <leader>nb  <Plug>(NoteBrowse)<cr>
nmap <buffer> <leader>npp <Plug>(PdfDocument)<cr>
nmap <buffer> <leader>npb <Plug>(PdfBeamer)<cr>
nmap <buffer> <leader>nph <Plug>(HtmlPage)<cr>

nmap <buffer> <tab> <Plug>(NextLink)
nmap <buffer> <S-tab> <Plug>(PrevLink)
nmap <buffer> <backspace> <Plug>(Back)
nmap <buffer> <return> <Plug>(OpenLink)

nnoremap <buffer> - :HeaderIncrease<cr>
nnoremap <buffer> _ :HeaderDecrease<cr>

noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> <up>   gk
noremap <buffer> <silent> <down> gj

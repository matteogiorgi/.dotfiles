setlocal nonumber norelativenumber


tmap <buffer> <M-space> <C-\><C-n>:FloatermToggle<cr>
tmap <buffer> <silent><M-tab> <C-\><C-n>:FloatermNext<cr>
tmap <buffer> <silent><M-backspace> <C-\><C-n>:FloatermPrev<cr>
tmap <buffer> <silent><M-q> <C-\><C-n>:FloatermKill<cr>
tmap <buffer> <silent><M-n> <C-\><C-n>:FloatermNew<cr>

" tmap <buffer> <silent><M-h> <C-\><C-n>:FloatermHide<cr>

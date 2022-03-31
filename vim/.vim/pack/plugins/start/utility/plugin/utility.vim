" Load Mkdir
if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()


command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! Current call utility#Current()
command! Parent call utility#Parent()
command! GitDir call utility#GitDir()
command! Delete call utility#Delete()  " command! Delete :call delete(expand('%'))|Bclose
command! -nargs=* -complete=file -bang Rename call utility#Rename(<q-args>, '<bang>')


nnoremap <silent>' :ToggleAccent<CR>
nnoremap <C-w>h :call utility#WinMove('h')<CR>
nnoremap <C-w>j :call utility#WinMove('j')<CR>
nnoremap <C-w>k :call utility#WinMove('k')<CR>
nnoremap <C-w>l :call utility#WinMove('l')<CR>

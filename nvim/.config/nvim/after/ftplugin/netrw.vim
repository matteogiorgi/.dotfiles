setlocal bufhidden=wipe
setlocal signcolumn=yes:1


" 1.upadir 2.opendir 3.(un)hide
nmap <buffer> h -<esc>
nmap <buffer> l <cr>
nmap <buffer> . gh

" 1.(de)select 2.deselectall
nmap <buffer> <Tab>   mf
nmap <buffer> <S-Tab> mu

" 1.newdir 2.newfile 3.rename 4.delete 5.copy 6.move 7.execute
nmap <buffer> d d
nmap <buffer> f %:w<CR>:buffer #<CR>
nmap <buffer> R R
nmap <buffer> D D
nmap <buffer> c mtmc
nmap <buffer> m mtmm
nmap <buffer> x mx




" OLD MAPS
" noremap <buffer> d h
" noremap <buffer> h gj
" noremap <buffer> t gk
" noremap <buffer> n l
" noremap <buffer> e d
" noremap <buffer> l n

" noremap <buffer> h -
" noremap <buffer> l <return>

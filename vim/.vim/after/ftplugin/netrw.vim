setlocal bufhidden=wipe

" 1.upadir
" 2.opendir
" 3.(un)hide
nmap <buffer> h -<esc>
nmap <buffer> l <cr>
nmap <buffer> . gh

" 1.(de)select
" 2.deselectall
nmap <buffer> <Tab>   mf
nmap <buffer> <S-Tab> mu

" 1.newdir
" 2.newfile (buffer)
" 3.rename
" 4.delete
" 5.copy
" 6.move
" 7.execute
" 8.find
nmap <buffer> d d
nmap <buffer> f %:w<CR>:buffer #<CR>
nmap <buffer> R R
nmap <buffer> D D
nmap <buffer> c mtmc
nmap <buffer> m mtmm
nmap <buffer> x mx

" smalls plugin
if &rtp =~ 'vim-smalls'
    nmap <buffer> s <Plug>(smalls)
    omap <buffer> s <Plug>(smalls)
    xmap <buffer> s <Plug>(smalls)
endif

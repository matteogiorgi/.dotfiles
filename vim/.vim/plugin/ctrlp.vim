let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'


nnoremap <leader>d :CtrlPMixed<CR>
nnoremap <leader>f :CtrlPCurWD<CR>
nnoremap <leader>g :CtrlPUndo<CR>
nnoremap <leader>h :CtrlPMRU<CR>
nnoremap <leader>j :CtrlPChangeAll<CR>
nnoremap <leader>k :CtrlPBuffer<CR>
nnoremap <leader>l :CtrlPLine<CR>

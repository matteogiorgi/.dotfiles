let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'


nnoremap <leader>f :CtrlPCurWD<CR>
nnoremap <leader>u :CtrlPUndo<CR>
nnoremap <leader>h :CtrlPMRU<CR>
nnoremap <leader>j :CtrlPBuffer<CR>
nnoremap <leader>k :CtrlPChange<CR>
nnoremap <leader>l :CtrlPLine<CR>

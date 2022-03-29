" Menu remaps{{{
nnoremap <leader>aq :quitall<CR>
nnoremap <leader>aw :wall<CR>
nnoremap <leader>bw :write<CR>
nnoremap <leader>bd :Bclose<CR>
nnoremap <leader>bk :bdelete<CR>
nnoremap <leader>wd :wincmd q<cr>
nnoremap <leader>wt :wincmd T<cr>
nnoremap <leader>wo :only<CR>
nnoremap <leader>tt :tabs<CR>
nnoremap <leader>td :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
"}}}

" Outofmenu remaps{{{
vnoremap <silent><Tab> >gv
vnoremap <silent><S-Tab> <gv
nnoremap <silent><Left> :tabprevious<CR>
nnoremap <silent><Right> :tabnext<CR>
nnoremap <silent><S-Left> :tabmove -1<cr>
nnoremap <silent><S-Right> :tabmove +1<cr>
nnoremap <silent>Y y$
tnoremap <silent><C-q> <C-\><C-n>
nnoremap <silent><Tab> :wincmd w<cr>
nnoremap <silent><Backspace> :b#<cr>
nnoremap <silent><Up> {
nnoremap <silent><Down> }
nnoremap <silent><C-h> :vertical resize -5<CR>
nnoremap <silent><C-l> :vertical resize +5<CR>
nnoremap <silent><C-j> :resize -5<CR>
nnoremap <silent><C-k> :resize +5<CR>
nnoremap <leader>r :%s///gc<Left><Left><Left>
xnoremap <leader>r :s///gc<Left><Left><Left>
nnoremap <leader>wH :wincmd<Space>H<CR>
nnoremap <leader>wL :wincmd<Space>L<CR>
nnoremap <leader>wJ :wincmd<Space>J<CR>
nnoremap <leader>wK :wincmd<Space>K<CR>
nnoremap <leader>0 0gt
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nnoremap <leader>t0 :0tabmove<cr>
nnoremap <leader>t1 :1tabmove<cr>
nnoremap <leader>t2 :2tabmove<cr>
nnoremap <leader>t3 :3tabmove<cr>
nnoremap <leader>t4 :4tabmove<cr>
nnoremap <leader>t5 :5tabmove<cr>
nnoremap <leader>t6 :6tabmove<cr>
nnoremap <leader>t7 :7tabmove<cr>
nnoremap <leader>t8 :8tabmove<cr>
nnoremap <leader>t9 :9tabmove<cr>
"}}}

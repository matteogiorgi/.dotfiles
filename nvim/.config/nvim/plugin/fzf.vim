" This section is for general FZF,
" it just needs to have FZF installed in the system

function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

function! s:FzfBufName()
    0f
    file [Fzf]
endfunction


" In case you use window mode,
" you'll need a new statusline ;)
augroup fzflines
    autocmd!
    autocmd User FzfStatusLine setlocal statusline=\ >>\ fzf  " %#Fzf1#
    autocmd BufCreate,TermOpen,BufWinEnter,WinEnter term://*#FZF,term://*/run call s:FzfBufName()
augroup END


" standard colors for FZF with the exception of:
" 'border' : ['fg', 'Ignore'],
let g:fzf_colors = {
            \ 'fg'      : ['fg', 'Normal'],
            \ 'bg'      : ['bg', 'Normal'],
            \ 'hl'      : ['fg', 'Comment'],
            \ 'fg+'     : ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+'     : ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+'     : ['fg', 'Statement'],
            \ 'info'    : ['fg', 'PreProc'],
            \ 'border'  : ['bg', 'StatusLine'],
            \ 'prompt'  : ['fg', 'Conditional'],
            \ 'pointer' : ['fg', 'Exception'],
            \ 'marker'  : ['fg', 'Keyword'],
            \ 'spinner' : ['fg', 'Label'],
            \ 'header'  : ['fg', 'Comment']
            \ }
let g:fzf_action = {
            \ 'ctrl-q' : function('s:build_quickfix_list'),
            \ 'ctrl-t' : 'tab split',
            \ 'ctrl-s' : 'split',
            \ 'ctrl-v' : 'vsplit'
            \ }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_preview_window = ['right:60%', 'ctrl-/']
let g:fzf_layout = { 'window': 'enew' }

" other layouts (uncomment the one you prefere)
" let g:fzf_layout = { 'down': '30%' }
" let g:fzf_layout = { 'window': 'tabnew' }
" let g:fzf_layout = {
"             \ 'window': {
"             \     'width': 0.30,
"             \     'height': 0.70,
"             \     'yoffset': 0.50,
"             \     'xoffset': 0.50,
"             \     'border': 'sharp',
"             \     'highlight': 'Normal',
"             \     }
"             \ }

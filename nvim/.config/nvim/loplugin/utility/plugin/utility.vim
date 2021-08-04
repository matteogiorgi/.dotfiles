" Load Mkdir
if !exists("g:mkdir_loaded") | let g:mkdir_loaded=1 | endif
autocmd! BufWritePre * call utility#Mkdir()
autocmd! CmdlineLeave : call timer_start(5000, funcref('s:ClearCMD'))


" Terminal settings{{{
" UNUSED (there are already floaterm config)
" augroup termsettings
"     autocmd!
"     autocmd BufCreate,TermOpen,BufWinEnter,WinEnter,BufEnter,FocusGained term://* startinsert
"     autocmd BufDelete,TermClose,BufWinLeave,WinLeave,BufLeave,FocusLost term://* stopinsert | set showmode
"     autocmd BufCreate,TermOpen,TermEnter term://* call utility#TermMappings('shell')
" augroup end
"}}}


" Clear command-line
function! s:ClearCMD(timer)
    if mode() ==# 'n'
        echon ''
    endif
endfunction

" Display an error message.
function! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
endfunction


command! LongLine call utility#LongLine()
command! ToggleAccent call utility#ToggleAccent()
command! Current call utility#Current()
command! Parent call utility#Parent()
command! GitDir call utility#GitDir()
command! Delete call utility#Delete()  " command! Delete :call delete(expand('%'))|Bclose
command! -nargs=* -complete=file -bang Rename call utility#Rename(<q-args>, '<bang>')


nnoremap <silent>' :ToggleAccent<CR>

nnoremap <silent><M-h> :call utility#WinMove('h')<CR>
nnoremap <silent><M-j> :call utility#WinMove('j')<CR>
nnoremap <silent><M-k> :call utility#WinMove('k')<CR>
nnoremap <silent><M-l> :call utility#WinMove('l')<CR>

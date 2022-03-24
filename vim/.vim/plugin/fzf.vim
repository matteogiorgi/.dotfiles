" This section is for general FZF,
" it just needs to have FZF installed in the system

function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

function! FzfExplore(...)
    let inpath = substitute(a:1, "'", '', 'g')
    if inpath == "" || matchend(inpath, '/') == strlen(inpath)
        execute "cd" getcwd() . '/' . inpath
        let cwpath = getcwd() . '/'
        let g:preview_window = g:fzf_preview_window
        let g:fzf_preview_window = []
        call fzf#run(fzf#wrap(fzf#vim#with_preview({'source': '/bin/ls -1ap', 'dir': cwpath, 'sink': 'FZFExplore', 'options': ['--prompt', cwpath]})))
    else
        let file = getcwd() . '/' . inpath
        execute "e" file
    endif
    let g:fzf_preview_window = g:preview_window
endfunction

function! s:FzfBufName()
    0f
    file [Fzf]
endfunction


" e FZF as file manager
" on open and as simple finder
augroup shutuponopen
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer *
    autocmd BufEnter * call utility#LaunchOnopen('FZFExplore')
augroup END

" In case you use window mode,
" you'll need a new statusline ;)
augroup fzflines
    autocmd!
    autocmd User FzfStatusLine setlocal statusline=\ >>\ fzf  " %#Fzf1#
    autocmd BufCreate,BufWinEnter,WinEnter term://*#FZF,term://*/run call s:FzfBufName()
augroup END


let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git" 2>/dev/null'
let $FZF_DEFAULT_OPTS='--bind "Right:preview-page-down,Left:preview-page-up"'  " Down:preview-down,Up:preview-up

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
let g:fzf_preview_window = ['up:80%', 'ctrl-/']
let g:fzf_layout = { 'window': 'enew' }


command! -nargs=* FZFExplore call FzfExplore(shellescape(<q-args>))


" Locate
nnoremap <leader>l :FZFExplore<CR>

" Commands
nnoremap <leader>k :Commands<CR>

" Find
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :BLines<CR>

" All
nnoremap <leader>aa :Rg<CR>
nnoremap <leader>al :Lines<CR>

" Buffers
nnoremap <leader>bb :Buffers<CR>

" Windows
nnoremap <leader>ww :Windows<CR>

" Git
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>gg :BCommits<CR>
nnoremap <leader>gr :Commits<CR>

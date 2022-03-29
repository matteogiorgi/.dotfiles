let g:which_key_sep = '→'
let g:which_key_max_size = 0
let g:which_key_vertical = 0
let g:which_key_hspace = 10
let g:which_key_sort_horizontal = 0
let g:which_key_disable_default_offset = 1
let g:which_key_centered = 1
let g:which_key_default_group_name = '?'
let g:which_key_timeout = 300
let g:which_key_position = 'botright'
let g:which_key_use_floating_win = 0
let g:which_key_exit = [
            \ "\<C-[>",
            \ "\<Esc>",
            \ "\<Space>",
            \ ]


" Generics{{{
let g:which_key_map = { 'name' : 'Menu',
            \ 'h' : 'htree',
            \ 'j' : 'jump',
            \ 'k' : 'command',
            \ 'l' : 'locate',
            \ 'r' : 'replace',
            \ }
"}}}

" Find{{{
let g:which_key_map['f'] = { 'name' : '+Find',
            \ 'f' : 'file',
            \ 'g' : 'gfile',
            \ 'h' : 'hfile',
            \ 'l' : 'line',
            \ }
"}}}

" Windows{{{
let g:which_key_map['w'] = { 'name' : '+Wins',
            \ 'w' : 'winlist',
            \ 'd' : 'delete',
            \ 't' : 'totab',
            \ 'o' : 'onlyone',
            \ }
"}}}

" Tabs{{{
let g:which_key_map['t'] = { 'name' : '+Tabs',
            \ 't' : 'tablist',
            \ 'd' : 'delete',
            \ 'o' : 'onlyone',
            \ }
"}}}

" Buffers{{{
let g:which_key_map['b'] = { 'name' : '+Bufs',
            \ 'b' : 'buflist',
            \ 'w' : 'write',
            \ 'd' : 'delete',
            \ 'k' : 'kill',
            \ }
"}}}

" Git{{{
let g:which_key_map['g'] = { 'name' : '+Git',
            \ 's' : 'status',
            \ 'g' : 'buffer',
            \ 'r' : 'repo',
            \ }
"}}}

" All{{{
let g:which_key_map['a'] = { 'name' : '+All',
            \ 'a' : 'aaarg',
            \ 'l' : 'lines',
            \ 'q' : 'quit',
            \ 'w' : 'write',
            \ }
"}}}

" Surround{{{
let g:which_key_map['s'] = { 'name' : '+Srnd',
            \ 's' : 'select',
            \ 'l' : 'line',
            \ 'r' : 'replace',
            \ 'd' : 'delete',
            \ }
"}}}


" Ignore{{{
let g:which_key_map.0   = 'which_key_ignore'
let g:which_key_map.1   = 'which_key_ignore'
let g:which_key_map.2   = 'which_key_ignore'
let g:which_key_map.3   = 'which_key_ignore'
let g:which_key_map.4   = 'which_key_ignore'
let g:which_key_map.5   = 'which_key_ignore'
let g:which_key_map.6   = 'which_key_ignore'
let g:which_key_map.7   = 'which_key_ignore'
let g:which_key_map.8   = 'which_key_ignore'
let g:which_key_map.9   = 'which_key_ignore'
let g:which_key_map.t.0 = 'which_key_ignore'
let g:which_key_map.t.1 = 'which_key_ignore'
let g:which_key_map.t.2 = 'which_key_ignore'
let g:which_key_map.t.3 = 'which_key_ignore'
let g:which_key_map.t.4 = 'which_key_ignore'
let g:which_key_map.t.5 = 'which_key_ignore'
let g:which_key_map.t.6 = 'which_key_ignore'
let g:which_key_map.t.7 = 'which_key_ignore'
let g:which_key_map.t.8 = 'which_key_ignore'
let g:which_key_map.t.9 = 'which_key_ignore'
let g:which_key_map.w.h = 'which_key_ignore'
let g:which_key_map.w.j = 'which_key_ignore'
let g:which_key_map.w.k = 'which_key_ignore'
let g:which_key_map.w.l = 'which_key_ignore'
let g:which_key_map.w.H = 'which_key_ignore'
let g:which_key_map.w.J = 'which_key_ignore'
let g:which_key_map.w.K = 'which_key_ignore'
let g:which_key_map.w.L = 'which_key_ignore'
"}}}


" I want to hide the statusline
" (specially in window-mode)
augroup whichkeystatusline
    autocmd!
    autocmd FileType which_key set laststatus=0 noshowmode noruler
                \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup end

" notewiki shortcuts
" (Pandoc shortcuts are hidden when inside non-markdown filetype)
augroup notesettings
    autocmd!
    autocmd BufEnter *
                \ if &filetype ==? 'markdown'  || &filetype ==? 'markdown.pandoc' || &filetype ==? 'pandoc' |
                \     let g:which_key_map['n'] = { 'name' : '+Note',
                \         'i' : 'index',
                \         'b' : 'browse',
                \         's' : 'scratch',
                \         'p' : 'pandoc',
                \         } |
                \ else |
                \     let g:which_key_map['n'] = { 'name' : '+Note',
                \         'i' : 'index',
                \         'b' : 'browse',
                \         's' : 'scratch',
                \         } |
                \ endif
augroup end


nnoremap <silent><leader> :WhichKey<space>' '<CR>
vnoremap <silent><leader> :WhichKeyVisual<space>' '<CR>

call which_key#register('<Space>', 'g:which_key_map')

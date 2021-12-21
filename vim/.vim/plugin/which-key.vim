let g:which_key_sep = '→'
let g:which_key_max_size = 0
let g:which_key_vertical = 0
let g:which_key_hspace = 20
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
            \ 'h' : 'history',
            \ 'j' : 'jump2',
            \ 'k' : 'commands',
            \ 'l' : 'locate',
            \ 'r' : 'replace',
            \ 'u' : 'undo3',
            \ }
"}}}

" Replace{{{
let g:which_key_map['m'] = { 'name' : '+MCrss',
            \ 'p' : 'position',
            \ 'w' : 'word',
            \ 'r' : 'range',
            \ 'o' : 'operator',
            \ }
"}}}

" Coc{{{
let g:which_key_map['c'] = { 'name' : '+COCopt',
            \ 'a' : 'action',
            \ 'c' : 'command',
            \ 'l' : 'list',
            \ 'g' : { 'name' : '+Goto',
            \     'd' : 'definition',
            \     't' : 'type-definition',
            \     'i' : 'implementation',
            \     'r' : 'reference',
            \     }
            \ }
"}}}

" Find{{{
let g:which_key_map['f'] = { 'name' : '+Find',
            \ 'l' : 'line',
            \ 'm' : 'mark',
            \ 'c' : 'change',
            \ 'g' : 'grep',
            \ 'y' : 'yank',
            \ 'f' : { 'name' : '+File',
            \     'f' : './',
            \     'g' : 'git',
            \     'r' : 'recent',
            \     }
            \ }
"}}}

" Windows{{{
let g:which_key_map['w'] = { 'name' : '+WinCMD',
            \ 'w' : 'windows',
            \ 'd' : 'delete',
            \ 'l' : 'list',
            \ 'r' : 'rotate',
            \ 'e' : 'equalize',
            \ 't' : '2tab',
            \ 'o' : 'one',
            \ 'n' : { 'name' : '+New',
            \     'n' : 'editnew',
            \     's' : 'split',
            \     'v' : 'vsplit',
            \     }
            \ }
"}}}

" Tabs{{{
let g:which_key_map['t'] = { 'name' : '+TabCMD',
            \ 't' : 'tabs',
            \ 'd' : 'delete',
            \ 'n' : 'new',
            \ 'o' : 'one',
            \ }
"}}}

" Buffers{{{
let g:which_key_map['b'] = { 'name' : '+BufCMD',
            \ 'b' : 'buffers',
            \ 'w' : 'write',
            \ 'W' : 'writeall',
            \ 'd' : 'delete',
            \ 'D' : 'delWin',
            \ 'n' : 'new',
            \ }
"}}}

" Git{{{
let g:which_key_map['g'] = { 'name' : '+Git',
            \ 's' : 'status',
            \ 'g' : 'commits',
            \ 'b' : 'buffer',
            \ 'c' : 'chunk',
            \ }
"}}}

" Quit{{{
let g:which_key_map['q'] = { 'name' : '+Quit',
            \ 'q' : 'quit',
            \ 'Q' : 'w&q',
            \ }
"}}}

" Surround{{{
let g:which_key_map['s'] = { 'name' : '+Surrnd',
            \ 's' : 'select',
            \ 'w' : 'word',
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
                \     let g:which_key_map['n'] = { 'name' : '+Notes',
                \         'i' : 'index',
                \         'b' : 'browse',
                \         's' : 'scratch',
                \         'p' : 'pandoc',
                \         } |
                \ else |
                \     let g:which_key_map['n'] = { 'name' : '+Notes',
                \         'i' : 'index',
                \         'b' : 'browse',
                \         's' : 'scratch',
                \         } |
                \ endif
augroup end


nnoremap <silent><leader> :WhichKey<space>' '<CR>
vnoremap <silent><leader> :WhichKeyVisual<space>' '<CR>

call which_key#register('<Space>', 'g:which_key_map')

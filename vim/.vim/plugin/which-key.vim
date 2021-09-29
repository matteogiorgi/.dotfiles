let g:which_key_sep = '→'
let g:which_key_max_size = 0
let g:which_key_vertical = 0
let g:which_key_hspace = 12
let g:which_key_sort_horizontal = 0
let g:which_key_disable_default_offset = 1
let g:which_key_centered = 1
let g:which_key_floating_opts = {
            \ 'row': '+2',
            \ 'col': '+0',
            \ 'width': '+0',
            \ 'height': '-2'
            \ }
let g:which_key_default_group_name = '?'
let g:which_key_timeout = 300
let g:which_key_exit = [
            \ "\<C-[>",
            \ "\<Esc>",
            \ "\<Space>",
            \ ]
let g:which_key_display_names = {
            \ ' '    : 'SPC',
            \ '<C-H>': 'BS',
            \ '<C-I>': '⇆',
            \ '<TAB>': '⇆',
            \ '<CR>' : '↵',
            \ }
let g:which_key_position = 'botright'
let g:which_key_use_floating_win = 0


" I want to hide the statusline
" (specially in window-mode)
augroup whichkeystatusline
    autocmd!
    autocmd FileType which_key set laststatus=0 noshowmode noruler
                \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END


" Generics{{{
let g:which_key_map = { 'name' : 'Menu',
            \ 'e' : 'explore',
            \ 'a' : 'align',
            \ 'j' : 'jumpto',
            \ 'r' : 'replace',
            \ 'u' : 'undo3',
            \ 'd' : 'diagstics',
            \ }
"}}}

" Replace{{{
let g:which_key_map['m'] = { 'name' : '+MultiCrs',
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
            \ 't' : 'totab',
            \ 'n' : 'new',
            \ 'o' : 'only1',
            \ }
"}}}

" Tabs{{{
let g:which_key_map['t'] = { 'name' : '+TabCMD',
            \ 't' : 'tabs',
            \ 'd' : 'delete',
            \ 'n' : 'new',
            \ 'o' : 'only1',
            \ }
"}}}

" Buffers{{{
let g:which_key_map['b'] = { 'name' : '+BufCMD',
            \ 'b' : 'buffers',
            \ 'w' : 'write',
            \ 'W' : 'writeall',
            \ 'd' : 'delete',
            \ 'D' : 'delWin',
            \ }
"}}}

" Sessions{{{
let g:which_key_map['S'] = { 'name' : '+SsnCMD',
            \ 'S' : 'sessions',
            \ 's' : 'save',
            \ 'r' : 'restart',
            \ }
"}}}

" Quit{{{
let g:which_key_map['q'] = { 'name' : '+Quit',
            \ 'q' : 'quitEvil',
            \ 'Q' : 'quitWrite',
            \ 's' : 'splash',
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
let g:which_key_map.1 = 'which_key_ignore'
let g:which_key_map.2 = 'which_key_ignore'
let g:which_key_map.3 = 'which_key_ignore'
let g:which_key_map.4 = 'which_key_ignore'
let g:which_key_map.5 = 'which_key_ignore'
let g:which_key_map.6 = 'which_key_ignore'
let g:which_key_map.7 = 'which_key_ignore'
let g:which_key_map.8 = 'which_key_ignore'
let g:which_key_map.9 = 'which_key_ignore'
let g:which_key_map.0 = 'which_key_ignore'
let g:which_key_map.w.h = 'which_key_ignore'
let g:which_key_map.w.j = 'which_key_ignore'
let g:which_key_map.w.k = 'which_key_ignore'
let g:which_key_map.w.l = 'which_key_ignore'
let g:which_key_map.w.H = 'which_key_ignore'
let g:which_key_map.w.J = 'which_key_ignore'
let g:which_key_map.w.K = 'which_key_ignore'
let g:which_key_map.w.L = 'which_key_ignore'
"}}}


augroup notesettings
    autocmd!
    autocmd BufEnter *
                \ if &filetype ==? 'markdown'  || &filetype ==? 'markdown.pandoc' || &filetype ==? 'pandoc' |
                \     let g:which_key_map['n'] = { 'name' : '+Notes',
                \         'i' : 'index',
                \         'b' : 'browse',
                \         's' : 'scratch',
                \         'p' : { 'name' : '+Pandoc',
                \             'p' : 'pdf',
                \             'b' : 'beamer',
                \             'h' : 'html',
                \             },
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

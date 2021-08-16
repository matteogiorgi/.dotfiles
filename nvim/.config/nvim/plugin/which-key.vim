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
let g:which_key_use_floating_win = 1


" in case you wana hide the statusline in
" window-mode, uncomment the following autogroup
" augroup whichkeystatusline
"     autocmd!
"     autocmd FileType which_key set laststatus=0 noshowmode noruler
"                 \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" augroup END


" Generics{{{
let g:which_key_map = { 'name' : 'Menu',
            \ 'l' : 'listbuf',
            \ 'a' : 'alignat',
            \ 'j' : 'jumpto',
            \ 'r' : 'replace',
            \ 'u' : 'undotree',
            \ 'h' : 'explore',
            \ 'k' : 'fastseek',
            \ 'g' : 'gitcli',
            \ }
"}}}

" NoteWiki{{{
let g:which_key_map['n'] = { 'name' : '+Notes',
            \ 'i' : 'index',
            \ 'b' : 'browse',
            \ 's' : 'scratch',
            \ }
"}}}

" Replace{{{
let g:which_key_map['m'] = { 'name' : '+Multi',
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
            \ 'l' : 'lines',
            \ 'm' : 'marks',
            \ 'w' : 'words',
            \ 'y' : 'yanks',
            \ 'f' : { 'name' : '+Files',
            \     'f' : './',
            \     'g' : 'git',
            \     'h' : 'mru',
            \     }
            \ }
"}}}

" Workspace{{{
let g:which_key_map['w'] = { 'name' : '+WinCMD',
            \ 'w' : 'winext',
            \ 'r' : 'rotate',
            \ 'e' : 'equalize',
            \ 't' : 'totab',
            \ 'n' : { 'name' : '+New',
            \     't' : 'tab',
            \     'w' : 'window',
            \     },
            \ 'o' : { 'name' : '+Only',
            \     't' : 'tab',
            \     'w' : 'window',
            \     }
            \ }
"}}}

" Sessions{{{
let g:which_key_map['e'] = { 'name' : '+EditSS',
            \ 'l' : 'list',
            \ 's' : 'save',
            \ }
"}}}

" Quit{{{
let g:which_key_map['q'] = { 'name' : '+Quit',
            \ 'w' : 'window',
            \ 't' : 'tab',
            \ 'q' : 'all',
            \ }
"}}}

" Save{{{
let g:which_key_map['z'] = { 'name' : '+Save',
            \ 'z' : 'file',
            \ 'a' : 'all',
            \ }
"}}}

" Delete{{{
let g:which_key_map['d'] = { 'name' : '+Delete',
            \ 'q' : '&quit',
            \ 'f' : 'file',
            \ 'a' : 'all',
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
"}}}




nnoremap <silent><leader> :WhichKey<space>' '<CR>
vnoremap <silent><leader> :WhichKeyVisual<space>' '<CR>

call which_key#register('<Space>', 'g:which_key_map')

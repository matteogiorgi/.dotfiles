let g:floaterm_title = 'FT $1.$2'  " '$1|$2'
let g:floaterm_wintype = 'float'  " split,float
let g:floaterm_position = 'bottom'  " center,bottom,tab,botright
let g:floaterm_width = 1.00
let g:floaterm_height = 0.40  " 0.40,1.00
let g:floaterm_opener = 'edit'  " edit,drop
let g:floaterm_autoclose = 1
let g:floaterm_autohide = 2
let g:floaterm_autoinsert = 1
let g:floaterm_rootmarkers = ['.project', '.git', '.hg', '.svn', '.root']
let g:floaterm_borderchars = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']  " ['▀', '█', '▄', '█', '█', '█', '█', '█']


" isdir{{{
function! s:isdir(dir) abort
    let l:isempty = !empty(a:dir)
    let l:isdirectory = isdirectory(a:dir)
    let l:systemshit = !empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)
    return l:isempty && (l:isdirectory || l:systemshit)
endfunction
"}}}

" launchvifm{{{
function! s:launchexplorer()
    let l:directory = expand('%:p')
    if <SID>isdir(l:directory)
        execute 'Bclose'
        if len(getbufinfo({'buflisted':1})) ==? 1 && bufname('%') ==? ''
            execute 'cd ' . l:directory
            execute "Dashboard"
        else
            execute 'tabnew | cd ' . l:directory
            execute "Dashboard"
        endif
    endif
endfunction
"}}}

" I choose not to chose{{{
function s:chfiler() abort
    if !exists("g:current_filer")
        let g:current_filer = 'broot'
        return
    endif
    
    if g:current_filer ==? 'vifm'
        let g:current_filer = 'ranger'
        echomsg 'changed seeker to ranger'
    elseif g:current_filer ==? 'ranger'
        let g:current_filer = 'broot'
        echomsg 'changed seeker to broot'
    else
        let g:current_filer = 'vifm'
        echomsg 'changed seeker to vifm'
    endif
endfunction
"}}}

" Open seeker{{{
function s:fastfinder() abort
    if g:current_filer ==? 'vifm'
        execute 'FloatermNew vifm'
    elseif g:current_filer ==? 'ranger'
        execute 'FloatermNew ranger'
    elseif g:current_filer ==? 'broot'
        execute 'FloatermNew broot'
    else
        execute 'FloatermNew vifm'
    endif
endfunction
"}}}

" Git client{{{
function s:gitcli() abort
    execute 'call utility#GitDir()'
    if isdirectory('.git')
        execute 'cd %:p:h'
        if system('echo $(git rev-list --all --count)') == 0
            execute 'FloatermNew tig status'
        else
            execute 'FloatermNew tig'
        endif
    else
        execute 'cd %:p:h'
        execute "echohl WarningMsg | echomsg 'Not in a git repository'"
    endif
endfunction
"}}}


augroup shutuponopen
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer *
    autocmd BufEnter * call <SID>launchexplorer()
augroup END

augroup setonopen
    autocmd!
    autocmd VimEnter * call <SID>chfiler()
augroup END

augroup floatermmode
    autocmd!
    autocmd TermOpen,TermEnter * startinsert | set noshowmode | execute "echohl WarningMsg | echomsg ' Alt + Q (Quit) | N (New) | TAB (Next) | BSP (Prev) '"
    autocmd TermClose,TermLeave * stopinsert | set showmode
augroup end


command! GitCLI call <SID>gitcli()
command! FastFinder call <SID>fastfinder()
command! ChFiler call <SID>chfiler()


nnoremap <silent><M-space> :FloatermToggle<cr>

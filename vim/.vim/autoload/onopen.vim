" isdir{{{
function! s:isdir(dir) abort
    let l:isempty = !empty(a:dir)
    let l:isdirectory = isdirectory(a:dir)
    let l:systemshit = !empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)
    return l:isempty && (l:isdirectory || l:systemshit)
endfunction
"}}}

" launchFM{{{
" Bclose is needed
function! onopen#launch()
    let l:directory = expand('%:p')
    if <SID>isdir(l:directory)
        execute 'Bclose'
        if len(getbufinfo({'buflisted':1})) !=? 1 || bufname('%') !=? ''
            execute 'tabnew'
        endif
        execute 'cd ' . l:directory
        execute 'FZF'
    endif
endfunction
"}}}

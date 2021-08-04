" StatuslineGit{{{
function! statusline#StatuslineGit()
    " whithout gitbranch library you can use the following line to print git
    " branch name (even thow it doesn't work as good):
    " system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    let l:branchname = gitbranch#name()
    return strlen(l:branchname) > 0 ? toupper(l:branchname).' -- ':''
endfunction
"}}}

" Path{{{
function! statusline#Path()
    let l:bufname = expand('%')
    if l:bufname ==? ''
        return '[No Name]'
    endif

    let l:vimdir = getcwd()
    let l:bufdir = expand('%:p:h')
    if l:vimdir ==? l:bufdir
       return l:bufname
    endif

    let l:fullpath = expand('%:p')
    let l:shortpath = pathshorten(expand(l:fullpath))
    return l:shortpath
endfunction
"}}}

" BufferStatus{{{
function! statusline#BufferStatus()
    let l:status = ' '
    if &readonly
        let l:status .= '[x]'
    elseif &modified
        let l:status .= '[+]'
    endif
    return l:status
endfunction
"}}}

" LineInfo{{{
function! statusline#LineInfo()
    let l:column = virtcol('.')
    let l:line = line('.')
    let l:info = line.','.column
    return l:info
endfunction
"}}}

" LinePercent{{{
function! statusline#LinePercent()
    let l:byte = line2byte( line( '.' ) ) + col( '.' ) - 1
    let l:size = (line2byte( line( '$' ) + 1 ) - 1)
    let l:info = ((byte * 100)/size).'%'
    return l:info
endfunction
"}}}

" CocStatus{{{
function! statusline#CocStatus()
    let l:info = coc#status() == '' ? 'OK'
                \ : coc#status() . get(b:,'coc_current_function','')
    return l:info
endfunction
"}}}

" Spaces{{{
function! statusline#Spaces(num)
    let l:spaces = ''
    let l:n = 0
    while l:n < a:num
        let l:spaces .= ' '
        let l:n += 1
    endwhile
    return l:spaces
endfunction
"}}}

" Scrollbar{{{
function! statusline#Scrollbar()
    let width = 9
    let perc = (line('.') - 1.0) / (max([line('$'), 2]) - 1.0)
    let before = float2nr(round(perc * (width - 3)))
    let after = width - 3 - before
    return '[' . repeat(' ',  before) . '=' . repeat(' ', after) . ']'
endfunction
"}}}

" StatuslineGit{{{
function! lines#StatuslineGit()
    " whithout gitbranch library you can use the following line to print git
    " branch name (even thow it doesn't work as good):
    " system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    let l:branchname = gitbranch#name()
    return strlen(l:branchname) > 0 ? toupper(l:branchname).' -- ':''
endfunction
"}}}

" Path{{{
function! lines#Path()
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
function! lines#BufferStatus()
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
function! lines#LineInfo()
    let l:column = virtcol('.')
    let l:line = line('.')
    let l:info = line.','.column
    return l:info
endfunction
"}}}

" LinePercent{{{
function! lines#LinePercent()
    let l:byte = line2byte( line( '.' ) ) + col( '.' ) - 1
    let l:size = (line2byte( line( '$' ) + 1 ) - 1)
    let l:info = ((byte * 100)/size).'%'
    return l:info
endfunction
"}}}

" CocStatus{{{
function! lines#CocStatus()
    let l:info = coc#status() == '' ? 'OK'
                \ : coc#status() . get(b:,'coc_current_function','')
    return l:info
endfunction
"}}}

" Spaces{{{
function! lines#Spaces(num)
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
function! lines#Scrollbar()
    let width = 9
    let perc = (line('.') - 1.0) / (max([line('$'), 2]) - 1.0)
    let before = float2nr(round(perc * (width - 3)))
    let after = width - 3 - before
    return '[' . repeat(' ',  before) . '=' . repeat(' ', after) . ']'
endfunction
"}}}

" Tabline status{{{
" UNUSED
function! lines#TabStatus()
    let l:s = ''
    for i in range(tabpagenr('$'))
        let tabnr = i + 1 " range() starts at 0
        let winnr = tabpagewinnr(tabnr)
        let buflist = tabpagebuflist(tabnr)
        let bufnr = buflist[winnr - 1]

        if getcwd() ==? fnamemodify(bufname(bufnr), ':p:h')
            let bufname = fnamemodify(bufname(bufnr), ':t')
        else
            let bufname = pathshorten(fnamemodify(bufname(bufnr), ':p'))
        endif

        let l:s .= '%' . tabnr . 'T'
        let l:s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let l:s .= ' ' . tabnr

        let n = tabpagewinnr(tabnr,'$')
        if n > 1 | let l:s .= ':' . n | endif

        let l:s .= empty(bufname) ? ' [No Name] ' : ' ' . bufname . ' '

        let bufmodified = getbufvar(bufnr, '&mod')
        if bufmodified | let l:s .= '[+] ' | endif
    endfor
    let l:s .= '%#TabLineFill#'
    return l:s
endfunction
"}}}

" I would like to split this function and add `%{ObsessionStatus()}` to track
" the status of the session.
function! tabline#TabStatus()
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

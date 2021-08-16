" LongLine{{{
function! utility#LongLine()
    if !exists('g:longline')
        let g:longline = 'none'
    endif
    if g:longline ==? 'none'
        let g:longline = 'all'
        setlocal virtualedit=all
    else
        let g:longline = 'none'
        setlocal virtualedit=
    endif
endfunction
"}}}

" ToggleAccent{{{
function! utility#ToggleAccent()
    let withAccentGrave = ['à', 'è', 'ì', 'ò', 'ù', 'À', 'È', 'Ì', 'Ò', 'Ù']
    let withAccentAcute = ['á', 'é', 'í', 'ó', 'ú', 'Á', 'É', 'Í', 'Ó', 'Ú']
    let withNoAccent    = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']
    let character = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let positionG = match(withAccentGrave, character)
    let positionA = match(withAccentAcute, character)
    let positionN = match(withNoAccent, character)
    if positionN != -1
        execute ':normal! r' . withAccentGrave[positionN]
    endif
    if positionG != -1
        execute ':normal! r' . withAccentAcute[positionG]
    endif
    if positionA != -1
        execute ':normal! r' . withNoAccent[positionA]
    endif
endfunction
"}}}

" WinMove{{{
function! utility#WinMove(key)
    let t:curwin = winnr()
    exec 'wincmd '.a:key
    if t:curwin ==? winnr()
        if match(a:key,'[jk]')
            wincmd v
        else
            wincmd s
        endif
        exec 'wincmd '.a:key
    endif
    return bufname('%')
endfunction
"}}}

" Jump current directory{{{
" UNUSED
function! utility#Current()
    echon 'cwd: '
    cd %:p:h
    echon getcwd()
endfunction
"}}}

" Jump parent directory{{{
" UNUSED
function! utility#Parent()
    echon 'cwd: '
    let l:parent = fnamemodify('getcwd()', ':p:h:h')
    execute 'cd ' . l:parent
    echon getcwd()
endfunction
"}}}

" Jump git directory{{{
" USED IN COMBO WITH COC-LIST AND/OR FZF
function! utility#GitDir()
    if getcwd() ==? $HOME
        " echon 'Not in a git repository'
        return
    endif

    if isdirectory('.git')
        " echon 'cwd: ' . getcwd()
        return
    else
        let l:parent = fnamemodify('getcwd()', ':p:h:h')
        execute 'cd ' . l:parent
        execute 'call utility#GitDir()'
    endif
endfunction
"}}}

" Mkdir{{{
function! utility#Mkdir()
    let dir = expand('%:p:h')
    if dir =~ '://' | return | endif
    if !isdirectory(dir)
        call mkdir(dir, 'p')
        echo 'Created non-existing directory: '.dir
    endif
endfunction
"}}}

" Delete{{{
function! utility#Delete()
    delete(expand('%'))
    Bclose
endfunction
"}}}

" Rename{{{
function! utility#Rename(name, bang)
	let l:name    = a:name
	let l:oldfile = expand('%:p')

	if bufexists(fnamemodify(l:name, ':p'))
		if (a:bang ==# '!')
			silent exe bufnr(fnamemodify(l:name, ':p')) . 'bwipe!'
		else
			echohl ErrorMsg
			echomsg 'A buffer with that name already exists (use ! to override).'
			echohl None
			return 0
		endif
	endif

	let l:status = 1

	let v:errmsg = ''
	silent! exe 'saveas' . a:bang . ' ' . l:name

	if v:errmsg =~# '^$\|^E329'
		let l:lastbufnr = bufnr('$')

		if expand('%:p') !=# l:oldfile && filewritable(expand('%:p'))
			if fnamemodify(bufname(l:lastbufnr), ':p') ==# l:oldfile
				silent exe l:lastbufnr . 'bwipe!'
			else
				echohl ErrorMsg
				echomsg 'Could not wipe out the old buffer for some reason.'
				echohl None
				let l:status = 0
			endif

			if delete(l:oldfile) != 0
				echohl ErrorMsg
				echomsg 'Could not delete the old file: ' . l:oldfile
				echohl None
				let l:status = 0
			endif
		else
			echohl ErrorMsg
			echomsg 'Rename failed for some reason.'
			echohl None
			let l:status = 0
		endif
	else
		echoerr v:errmsg
		let l:status = 0
	endif

	return l:status
endfunction
"}}}

" TermMappings{{{
" UNUSED (there are already floaterm config)
function! utility#TermMappings(arg)
    set noshowmode
    setlocal nonumber norelativenumber  "nobuflisted


    " The maps below are for resizing and reordering, besides moving through windows
    " I feel more confortabile just using Alt+t,e,q plus all the other commands in normal mode

    tmap <buffer> <silent><C-M-h> <C-\><C-n>:vertical resize -5<CR>i
    tmap <buffer> <silent><C-M-l> <C-\><C-n>:vertical resize +5<CR>i
    tmap <buffer> <silent><C-M-j> <C-\><C-n>:resize -5<CR>i
    tmap <buffer> <silent><C-M-k> <C-\><C-n>:resize +5<CR>i

    tmap <buffer> <silent><M-H> <C-\><C-n>:wincmd<Space>H<CR>i
    tmap <buffer> <silent><M-L> <C-\><C-n>:wincmd<Space>L<CR>i
    tmap <buffer> <silent><M-J> <C-\><C-n>:wincmd<Space>J<CR>i
    tmap <buffer> <silent><M-K> <C-\><C-n>:wincmd<Space>K<CR>i

    " This is just a wrapper to `buffer#`
    function! s:IfTerm(buffername)
        if a:buffername =~ 'term://*' | buffer# | endif
    endfunction

    tmap <buffer> <silent><M-h>      <C-\><C-n>:call <SID>IfTerm(utility#WinMove('h'))<CR>
    tmap <buffer> <silent><M-j>      <C-\><C-n>:call <SID>IfTerm(utility#WinMove('j'))<CR>
    tmap <buffer> <silent><M-k>      <C-\><C-n>:call <SID>IfTerm(utility#WinMove('k'))<CR>
    tmap <buffer> <silent><M-l>      <C-\><C-n>:call <SID>IfTerm(utility#WinMove('l'))<CR>
    
    tmap <buffer> <silent><M-Space>  <C-\><C-n>:wincmd w<cr>
    tmap <buffer> <silent><M-Return> <C-\><C-n>:CocList vimcommands<cr>

    tmap <buffer> <silent><M-Tab>    <C-\><C-n>:tabnext<cr>
    tmap <buffer> <silent><M-S-Tab>  <C-\><C-n>:tabprev<cr>
    tmap <buffer> <silent><M-<>      <C-\><C-n>:tabm -1<cr>
    tmap <buffer> <silent><M->>      <C-\><C-n>:tabm +1<cr>
    tmap <buffer> <silent><M-t>      <C-\><C-n>:wincmd T<cr>
    tmap <buffer> <silent><M-r>      <C-\><C-n>:wincmd r<cr>i
    tmap <buffer> <silent><M-=>      <C-\><C-n>:wincmd =<cr>
    tmap <buffer> <silent><M-o>      <C-\><C-n>:only<CR>
    tmap <buffer> <silent><M-O>      <C-\><C-n>:tabonly<CR>

    if a:arg ==? 'shell'
        tmap <buffer> <silent><M-q> <C-\><C-n>:Bclose!<cr>
        execute "redraw | echohl WarningMsg | echomsg 'TERM:  alt+q -> Quit'"
    endif
endfunction
"}}}

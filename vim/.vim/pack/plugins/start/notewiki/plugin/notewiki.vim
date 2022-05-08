let $wikipages = fnamemodify('~/notewiki', ':p')
let $pdfpages = fnamemodify('~/notewiki/pdf', ':p')
let $beamerpages = fnamemodify('~/notewiki/beamer', ':p')
let $htmlpages = fnamemodify('~/notewiki/html', ':p')

if !exists('g:notebrowser')
    let g:notebrowser = 'xhide $BROWSER'  "xdg-open
endif


if !isdirectory($wikipages)
    execute '!mkdir ' . $wikipages
endif


" EndPar{{{
function s:EndPar() abort
    execute 'normal o'
    execute 'normal o<!-- -->'
    execute 'normal o'
endfunction
"}}}

" CreateLink{{{
function s:CreateLink() abort
    let @z = ''
	execute 'normal ' . '"zyiw'
	if @z !=? ''
		execute 'normal ' . 'ciw[]()'
		execute 'normal ' . 'F[p'
		execute 'normal ' . 'f(p'
		execute 'normal ' . 'a.md'
		execute 'normal ' . 'F['
	endif
endfunction
"}}}

" NextLink{{{
function! s:NextLink() abort
    let link_regex = '\[[^]]*\]([^)]\+)'
    call search(link_regex)
endfunction
"}}}

" PrevLink{{{
function! s:PrevLink() abort
    let link_regex = '\[[^]]*\]([^)]\+)'
    call search(link_regex, 'b')
endfunction
"}}}

" OpenLink{{{
function! s:OpenLink() abort
	let fulllink = <SID>GetLink()
	if fulllink !=? ''
		execute 'normal ' . 'lT[f('
		execute 'normal ' . '"zyi('
		let splitname = split(@z, '\.')
		if len(splitname) ==? 0
			" do nothing
		elseif len(splitname) ==? 1
			if !exists('w:parents') | let w:parents = [] | endif
			let w:parents = [expand('%:t')] + w:parents
			execute 'edit ' . '%:p:h/' . @z . '.md'
		else
			if !exists('w:parents') | let w:parents = [] | endif
			let w:parents = [expand('%:t')] + w:parents
			execute 'edit ' . '%:p:h/' . @z
		endif
		call setreg('z', [])
	else
		call <SID>CreateLink()
	endif
endfunction
"}}}

" GetLink{{{
function! s:GetLink() abort
    let link_regex = '\[[^]]*\]([^)]\+)'
    let line = getline('.')
    let link = matchstr(line, '\%<'.(col('.')+1).'c'.link_regex.'\%>'.col('.').'c')
    return link
endfunction
"}}}

" GetWordLink(UNUSED){{{
function! s:GetWordLink() abort
    let word_regex = '[-+0-9A-Za-z_]\+'
    let line = getline('.')
    let word = matchstr(line, '\%<'.(col('.')+1).'c'.word_regex.'\%>'.col('.').'c')
    return word
endfunction
"}}}

" Back{{{
function! s:Back() abort
	if exists('w:parents') && len(w:parents) !=? 0
		let lastparent = w:parents[0]
		let w:parents = w:parents[1:]
		execute 'edit ' . '%:p:h/' . lastparent
	else
		echomsg 'You might be inside the root wiki already.'
	endif
endfunction
"}}}

" Scratch buffer{{{
" UNUSED
function s:ScratchBuffer()
    execute 'tabnew '
    file! SCRATCH
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal filetype=markdown.pandoc
endfunction
"}}}

" Browse main notes directory{{{
function s:NoteBrowseIndex()
    execute '!' . g:notebrowser . ' ' . $wikipages . ' &'
    execute 'redraw!'
endfunction
"}}}

" Browse current notes directory{{{
function s:NoteBrowse()
    execute '!' . g:notebrowser . ' ' . '%:p:h' . ' &'
    execute 'redraw!'
endfunction
"}}}


" Commands{{{
command! NoteWikiIndex :execute 'edit ' . $wikipages . '/index.md'
command! NoteBrowseIndex call <SID>NoteBrowseIndex()
command! -nargs=0 ScratchBuffer call <SID>ScratchBuffer()
"}}}

" Plug{{{
nnoremap <silent> <Plug>(NoteWiki)   :execute 'edit ' . '%:p:h' . '/index.md'<cr>
nnoremap <silent> <Plug>(NoteBrowse) :call <SID>NoteBrowse()<cr>
nnoremap <silent> <Plug>(NextLink)   :call <SID>NextLink()<cr>
nnoremap <silent> <Plug>(PrevLink)   :call <SID>PrevLink()<cr>
nnoremap <silent> <Plug>(OpenLink)   :call <SID>OpenLink()<cr>
nnoremap <silent> <Plug>(Back)       :call <SID>Back()<cr>
nnoremap <silent> <Plug>(EndPar)     :call <SID>EndPar()<cr>
"}}}

" maps{{{
nnoremap <leader>n :NoteWikiIndex<cr>
nnoremap <leader>N :NoteBrowseIndex<cr>
"}}}

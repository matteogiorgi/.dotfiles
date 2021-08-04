" NotePandoc{{{
function! s:NotePandoc(format) abort
    let l:prefix = expand('%:p:h')
    let l:currfile = expand('%:p')

    let $prefix = fnamemodify(l:prefix, ':p')
    let $prefixtail = fnamemodify(l:prefix, ':t')
    let $currfile = fnamemodify(l:currfile, ':p')

	if &filetype ==? 'markdown' || &filetype ==? 'markdown.pandoc' || &filetype ==? 'pandoc'
	    if a:format ==? 'pdf'
            let l:pdf = l:prefix . '/pdf'
            let $pdf = fnamemodify(l:pdf, ':p')
            if !isdirectory($pdf)
                !cp -R $HOME/.config/nvim/loplugin/notewiki/utils/pdf $prefix
            endif
            !pandoc $currfile --to=pdf -o $pdf/%:t:r.pdf --metadata-file=$pdf/pdf.yaml
        elseif a:format ==? 'beamer'
            let l:beamer = l:prefix . '/beamer'
            let $beamer = fnamemodify(l:beamer, ':p')
            if !isdirectory($beamer)
                !cp -R $HOME/.config/nvim/loplugin/notewiki/utils/beamer $prefix
            endif
            !pandoc $currfile --to=beamer -o $beamer/%:t:r.pdf --metadata-file=$beamer/beamer.yaml
        elseif a:format ==? 'html'
            let l:html = l:prefix . '/html'
            let $html = fnamemodify(l:html, ':p')
            if !isdirectory($html)
                !cp -R $HOME/.config/nvim/loplugin/notewiki/utils/html $prefix
            endif
            !pandoc $currfile -s --to=html5 -o $html/%:t:r.html
                        \ --mathjax
                        \ --highlight-style tango
                        \ -c $html/assets/style.css
                        \ --lua-filter=$html/assets/link2html.lua
                        \ -B $html/assets/prebody.html
                        \ -A $html/assets/footer.html
                        \ -H $html/assets/header.html
                        \ -T $prefixtail
        endif
	else
		echomsg 'This is not the file you are looking for.'
	endif
endfunction
"}}}


" Commands{{{
nnoremap <silent> <Plug>(PdfDocument) :call <SID>NotePandoc('pdf')
nnoremap <silent> <Plug>(PdfBeamer) :call <SID>NotePandoc('beamer')
nnoremap <silent> <Plug>(HtmlPage) :call <SID>NotePandoc('html')
"}}}

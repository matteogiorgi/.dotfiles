augroup shutuponopen
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer *
    autocmd BufEnter * call onopen#launch()
augroup END

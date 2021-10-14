augroup shutuponopen
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer *
    autocmd BufEnter * call onopen#launchfm()
augroup END

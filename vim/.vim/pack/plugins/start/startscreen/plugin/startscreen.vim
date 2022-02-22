if exists('g:loaded_startscreen') || &cp | finish | endif

let g:loaded_startscreen = 1
let s:save_cpo = &cpo

set cpo&vim


command! Startscreen call startscreen#start()
augroup startscreenstart
    autocmd!
    autocmd VimEnter * Startscreen
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

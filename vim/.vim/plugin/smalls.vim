let g:smalls_auto_jump = 1
let g:smalls_auto_jump_timeout = 0.5
let g:smalls_auto_jump_min_input_length = 3
let g:smalls_auto_set = 1
let g:smalls_auto_set_min_input_length = 1
let g:smalls_exit_at_notfound = 1

let s:excursion_table = { "\<CR>": 'do_set' }
call smalls#keyboard#excursion#extend_table(s:excursion_table)


nmap <silent><C-s> <Plug>(smalls)
omap <silent><C-s> <Plug>(smalls)
xmap <silent><C-s> <Plug>(smalls)

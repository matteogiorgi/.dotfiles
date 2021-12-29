let g:undotree_DiffAutoOpen = 1
let g:undotree_WindowLayout = 2
let g:undotree_ShortIndicators = 1
let g:undotree_SplitWidth = 40
let g:undotree_DiffpanelHeight = 10
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_HelpLine = 0


function! s:ToggleUT()
    if &filetype ==? 'dashboard' || buffer_name() =~ 'term://*' || buffer_name() =~ 'vifm:*' | return | endif
    if !exists('g:toggleUT') | let g:toggleUT = 0 | endif

    if g:toggleUT ==? 0
        let g:toggleUT = 1
        let g:tabn = tabpagenr()
        execute 'tabnew % | UndotreeShow'
    else
        let g:toggleUT = 0
        execute 'UndotreeHide | tabclose |  normal ' . g:tabn . 'gt'
    endif
endfunction


command! ToggleUT call <SID>ToggleUT()
nnoremap <leader>h :ToggleUT<CR>

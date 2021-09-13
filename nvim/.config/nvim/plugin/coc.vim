" Coc configuration file path and main extensions list
let g:coc_config_home = '~/.config/nvim'
let g:coc_global_extensions = [
            \ 'coc-dictionary',
            \ 'coc-omni',
            \ 'coc-syntax',
            \ 'coc-tabnine',
            \ 'coc-highlight',
            \ 'coc-lists',
            \ 'coc-git',
            \ 'coc-snippets',
            \ 'coc-yank',
            \ 'coc-explorer',
            \ 'coc-floaterm',
            \ 'coc-marketplace',
            \ ]


" The following LSP extensions works on top of the ones already configured
" in coc-settings.json so to have less extensions to load.

let g:coc_global_extensions = add(g:coc_global_extensions, 'coc-pyright')
let g:coc_global_extensions = add(g:coc_global_extensions, 'coc-json')
let g:coc_global_extensions = add(g:coc_global_extensions, 'coc-yaml')

let g:coc_explorer_global_presets = {
            \ 'float': {
            \     'position': 'floating',
            \     'floating-position': [float2nr(0.50*&columns-20),float2nr(0.10*&lines)],
            \     'floating-width': 40,
            \     'floating-height': float2nr(0.50*&lines),
            \     'open-action-strategy': 'select',
            \     },
            \ }


augroup hlcursor
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

augroup formatgroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

augroup explorerwindow
    autocmd! BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
    autocmd! VimLeavePre * execute 'CocCommand explorer --quit'
augroup end

augroup explorercursorline
    autocmd! User CocExplorerOpenPost set cursorline
augroup end

augroup explorerequalize
    autocmd! User CocExplorerOpenPost,CocExplorerQuitPost execute 'wincmd ='
augroup end


function! s:CheckBS() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:ShowDoc()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

function s:FindInGit() abort
    execute 'call utility#GitDir()'
    execute 'CocList files'
endfunction


command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')


inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>CheckBS() ? "\<TAB>" :
            \ coc#refresh()

inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
            \ : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

nnoremap <leader>ca  :CocAction<CR>
nnoremap <leader>cc  :CocCommand<CR>
nnoremap <leader>cl  :CocList<CR>
nmap     <leader>cgd <Plug>(coc-definition)
nmap     <leader>cgt <Plug>(coc-type-definition)
nmap     <leader>cgi <Plug>(coc-implementation)
nmap     <leader>cgr <Plug>(coc-references)

nmap <silent><tab>   <Plug>(coc-diagnostic-next)
nmap <silent><S-tab> <Plug>(coc-diagnostic-prev)

nnoremap <silent><M-return> :CocCommand explorer<CR>

nnoremap <silent>K   :call <SID>ShowDoc()<CR>
nnoremap <leader>k   :CocList vimcommands<CR>
nnoremap <leader>l   :CocList buffers<CR>

nnoremap <leader>fl  :CocList words<CR>
nnoremap <leader>fm  :CocList marks<CR>
nnoremap <leader>fw  :CocList grep<CR>
nnoremap <leader>fy  :CocList registers<CR>
nnoremap <leader>fff :CocList files<CR>
nnoremap <leader>ffg :call <SID>FindInGit()<CR>
nnoremap <leader>ffh :CocList mru<CR>

nnoremap <leader>esl :CocList sessions<CR>
nnoremap <leader>ess :CocCommand session.save<CR>

nmap <leader>mp <Plug>(coc-cursors-position)
nmap <leader>mw <Plug>(coc-cursors-word)
xmap <leader>mr <Plug>(coc-cursors-range)
nmap <leader>mo <Plug>(coc-cursors-operator)




""" EXPLORER CONFIG """

" let g:coc_explorer_global_presets = {
"             \ 'float01': {
"             \     'position': 'floating',
"             \     'floating-position': [float2nr(0.50*&columns-20),float2nr(0.10*&lines)],
"             \     'floating-width': 40,
"             \     'floating-height': float2nr(0.50*&lines),
"             \     'open-action-strategy': 'select',
"             \     },
"             \ 'float02': {
"             \     'position': 'floating',
"             \     'floating-position': [float2nr(0.50*&columns-20),float2nr(0.10*&lines)],
"             \     'floating-width': 40,
"             \     'floating-height': float2nr(0.50*&lines),
"             \     'open-action-strategy': 'sourceSource',
"             \     },
"             \ }

" function coc#Explorer(...) abort
"     if (a:0 > 0)
"         if (a:1 ==? 'float01')
"             execute 'CocCommand explorer --preset float01 ' . getcwd()
"         elseif (a:1 ==? 'float02')
"             execute 'CocCommand explorer --preset float02 ' . getcwd()
"         elseif (a:1 ==? 'float03')
"             let l:winnr        = winnr()
"             let l:winheight    = winheight(l:winnr)
"             let l:winwidth     = winwidth(l:winnr)
"             let l:winposheight = win_screenpos(l:winnr)[0]
"             let l:winposwidth  = win_screenpos(l:winnr)[1]
"             let l:posheight    = float2nr(l:winposheight + 0.10*l:winheight)
"             let l:poswidth     = float2nr(l:winposwidth + 0.50*l:winwidth - 20)
"             let l:height       = float2nr(0.50*l:winheight)
"             execute 'CocCommand explorer --position floating --floating-position '.l:poswidth.','.l:posheight.
"                         \ ' --floating-width 40 --floating-height '.l:height.
"                         \ ' --sources buffer+,file+ --open-action-strategy sourceWindow ' . getcwd()
"         endif
"     else
"         execute 'CocCommand explorer ' . getcwd()
"     endif
" endfunction




""" NO MAN'S LAND """

" nmap <leader>rn <Plug>(coc-rename)
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>ac <Plug>(coc-codeaction)
" nmap <leader>qf <Plug>(coc-fix-current)

" nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
" inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
" vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

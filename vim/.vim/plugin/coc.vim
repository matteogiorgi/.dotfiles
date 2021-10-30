
"                              COC-EXTENSIONS
"                  [ https://github.com/neoclide/coc.nvim ]
"
"     coc-marketplace···········https://github.com/fannheyward/coc-marketplace
"     coc-dictionary············https://github.com/neoclide/coc-sources
"     coc-highlight·············https://github.com/neoclide/coc-highlight
"     coc-snippets··············https://github.com/neoclide/coc-snippets
"     coc-lists·················https://github.com/neoclide/coc-lists
"     coc-git···················https://github.com/neoclide/coc-git
"     coc-yank··················https://github.com/neoclide/coc-yank




" Coc configuration file path and main extensions list
let g:coc_config_home = '~/.vim'
let g:coc_global_extensions = [
            \ 'coc-marketplace',
            \ 'coc-dictionary',
            \ 'coc-highlight',
            \ 'coc-snippets',
            \ 'coc-lists',
            \ 'coc-git',
            \ 'coc-yank',
            \ ]

" If you want an extension to work on top of the ones already configured
" in coc-settings.json, use the marketplace or just add the following:
" let g:coc_global_extensions = add(g:coc_global_extensions, 'some-coc-extension')


highlight! link CocExplorerSelectUI StatusLine

augroup cocstatusline
    autocmd!
    autocmd FileType list set laststatus=0 noshowmode noruler
                \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup end

augroup hlcursor
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

augroup formatgroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
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

nnoremap <silent>K  :call <SID>ShowDoc()<CR>
nnoremap <leader>d  :CocList diagnostics<CR>
nnoremap <leader>h  :CocList cmdhistory<CR>
nnoremap <leader>k  :CocList vimcommands<CR>
nnoremap <leader>bb :CocList buffers<CR>
nnoremap <leader>ww :CocList windows<CR>

nnoremap <leader>fl  :CocList words<CR>
nnoremap <leader>fm  :CocList marks<CR>
nnoremap <leader>fc  :CocList changes<CR>
nnoremap <leader>fg  :CocList grep<CR>
nnoremap <leader>fy  :CocList registers<CR>
nnoremap <leader>fff :CocList files<CR>
nnoremap <leader>ffg :call <SID>FindInGit()<CR>
nnoremap <leader>ffr :CocList mru<CR>

nnoremap <leader>gs :CocList gstatus<CR>
nnoremap <leader>gg :CocList commits<CR>
nnoremap <leader>gb :CocList bcommits<CR>
nnoremap <leader>gc :CocCommand git.showCommit<CR>

nmap <leader>mp <Plug>(coc-cursors-position)
nmap <leader>mw <Plug>(coc-cursors-word)
xmap <leader>mr <Plug>(coc-cursors-range)
nmap <leader>mo <Plug>(coc-cursors-operator)

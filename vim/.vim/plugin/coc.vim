" Coc configuration file path and main extensions list
let g:coc_config_home = '~/.vim'
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
            \ 'coc-marketplace',
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

nnoremap <silent>K   :call <SID>ShowDoc()<CR>
nnoremap <leader>k   :CocList vimcommands<CR>
nnoremap <leader>l   :CocList buffers<CR>
nnoremap <leader>ee  :CocCommand explorer<CR>
nnoremap <leader>wa  :CocList windows<CR>

nnoremap <leader>fl  :CocList words<CR>
nnoremap <leader>fm  :CocList marks<CR>
nnoremap <leader>fg  :CocList grep<CR>
nnoremap <leader>fy  :CocList registers<CR>
nnoremap <leader>fff :CocList files<CR>
nnoremap <leader>ffg :call <SID>FindInGit()<CR>
nnoremap <leader>ffr :CocList mru<CR>

nnoremap <leader>esl :CocList sessions<CR>
nnoremap <leader>ess :CocCommand session.save<CR>

nmap <leader>mp <Plug>(coc-cursors-position)
nmap <leader>mw <Plug>(coc-cursors-word)
xmap <leader>mr <Plug>(coc-cursors-range)
nmap <leader>mo <Plug>(coc-cursors-operator)


"                                   PLUGINS
"                  [ https://github.com/junegunn/vim-plug ]
"
"     coc-nvim··················https://github.com/neoclide/coc.nvim
"     vim-polyglot··············https://github.com/sheerun/vim-polyglot
"     vim-snippets··············https://github.com/honza/vim-snippets
"     auto-pairs················https://github.com/jiangmiao/auto-pairs
"     vim-surround··············https://github.com/tpope/vim-surround
"     vim-repeat················https://github.com/tpope/vim-repeat
"     vim-commentary············https://github.com/tpope/vim-commentary
"     vim-smalls················https://github.com/t9md/vim-smalls
"     undotree··················https://github.com/mbbill/undotree
"     tabular···················https://github.com/godlygeek/tabular
"     vim-move··················https://github.com/matze/vim-move
"     vim-which-key·············https://github.com/liuchengxu/vim-which-key
"     vim-pandoc-syntax·········https://github.com/vim-pandoc/vim-pandoc-syntax
"     vim-notewiki··············https://github.com/matteogiorgi/vim-notewiki
"     vim-lines·················https://github.com/matteogiorgi/vim-lines
"     vim-utility···············https://github.com/matteogiorgi/vim-utility
"     vim-explore···············https://github.com/matteogiorgi/vim-explore
"     vim-startscreen···········https://github.com/matteogiorgi/vim-startscreen


"                              COC-EXTENSIONS
"
"     coc-dictionary············https://github.com/neoclide/coc-sources
"     coc-omni··················https://github.com/neoclide/coc-sources
"     coc-syntax················https://github.com/neoclide/coc-sources
"     coc-tabnine···············https://github.com/neoclide/coc-tabnine
"     coc-highlight·············https://github.com/neoclide/coc-highlight
"     coc-lists·················https://github.com/neoclide/coc-lists
"     coc-git···················https://github.com/neoclide/coc-git
"     coc-snippets··············https://github.com/neoclide/coc-snippets
"     coc-yank··················https://github.com/neoclide/coc-yank
"     coc-explorer··············https://github.com/weirongxu/coc-explorer
"     coc-marketplace···········https://github.com/fannheyward/coc-marketplace




" Plug check{{{
augroup vimenter
    autocmd VimEnter *
                \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
                \     PlugInstall --sync | q |
                \ endif
    if !filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.vim}/autoload/plug.vim"'))
        echo 'Downloading junegunn/vim-plug to manage plugins...'
        silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
                    \ > ${XDG_CONFIG_HOME:-$HOME/.vim}/autoload/plug.vim
        autocmd VimEnter * PlugInstall
    endif
augroup end
"}}}


" Plugin list{{{
call plug#begin('~/.vim/plugged')
    Plug 'neoclide/coc.nvim', {'branch' : 'release'}
    Plug 'sheerun/vim-polyglot'
    Plug 'honza/vim-snippets'
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 't9md/vim-smalls'
    Plug 'mbbill/undotree'
    Plug 'godlygeek/tabular'
    Plug 'matze/vim-move'
    Plug 'liuchengxu/vim-which-key'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'matteogiorgi/vim-notewiki'
    Plug 'matteogiorgi/vim-lines'
    Plug 'matteogiorgi/vim-utility'
    Plug 'matteogiorgi/vim-explore'
    Plug 'matteogiorgi/vim-startscreen'
call plug#end()
"}}}


" Some settings to load early{{{
if exists('+termguicolors') | set termguicolors | endif
if has('linebreak') | let &showbreak='⤷ ' | endif
if has('persistent_undo')
    set undodir=$HOME/.vim/undodir
    set undofile
endif
"}}}


" Color syntax{{{
syntax on
set background=dark
colorscheme dracula  " dracula,spooky
filetype plugin indent on
"}}}

" Simple painter{{{
highlight! OverLength term=reverse gui=reverse
highlight! default link netrwMarkFile Search
"}}}

" Set extra{{{
set exrc
set title
"}}}

" Set cursor{{{
set guicursor=n-v:block-Cursor
set guicursor+=c:hor100-cCursor
set guicursor+=i:hor100-iCursor
set guicursor+=a:blinkon0  " blinkwait700-blinkon400-blinkoff250
"}}}


" Set mainstuff{{{
set shell=zsh  " zsh,bash
set nocompatible    " nvim is always nocompatible
set runtimepath+=~/.vim_runtime  " add whatever
set clipboard=unnamedplus
set number relativenumber mouse=a
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set ruler scrolloff=8 sidescrolloff=8
set autoindent
set formatoptions+=l
set hlsearch incsearch
set nowrap nospell  " set spell complete+=kspell
set ignorecase smartcase smartindent
set noswapfile nobackup
set showmode showcmd
set cursorline noerrorbells novisualbell
set splitbelow splitright
set noequalalways
set nofoldenable foldmethod=marker  "zf zd za zo zc zi zE zR zM
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=300  "default = 4000ms
set timeoutlen=300  "default = 1000ms
set termencoding=utf-8 encoding=utf-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=   " let &colorcolumn = '81,'.join(range(81,999),',')
set cmdheight=1
set fillchars+=vert:\│,eob:\ ,fold:-
set wildchar=<Tab> wildmenu wildmode=full
set guioptions-=e
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=Hasklig:h8.0
set laststatus=2 showtabline=2
"}}}

" Just for nvim{{{
" set signcolumn=auto:2
"}}}

" Set completion{{{
set path+=**
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest,noinsert,noselect
set complete+=k/usr/share/dict/british-english
set complete+=k/usr/share/dict/italian
set complete+=w,b
set dictionary+=/usr/share/dict/british-english
set dictionary+=/usr/share/dict/italian
set wildmenu  " wildmode=list:longest,list:full
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set shortmess+=c
set belloff+=ctrlg
"}}}


" Prevent Netrw to load{{{
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
"}}}


" Variables to load early{{{
let g:mapleader = "\<space>"
let g:maplocalleader = ","
if has('python3')
    let g:python3_host_prog = '/usr/bin/python3'
endif
"}}}


" Linenumber behaviour{{{
augroup numbertoggle
    autocmd!
    autocmd WinEnter,BufEnter,FocusGained,InsertLeave *
                \ if &number ==? 1 | set relativenumber | endif | set cursorline
    autocmd WinLeave,BufLeave,FocusLost,InsertEnter *
                \ if &number ==? 1 | set norelativenumber | endif | set nocursorline
augroup end
"}}}

" Overlength behaviour{{{
augroup overlengthtoggle
    autocmd!
    autocmd InsertEnter * match OverLength /\%81v/
    autocmd InsertLeave * match none
augroup end
"}}}


" Simple commands{{{
command! SelectAll execute "normal \ggVG"
command! IndentAll exe 'setl ts=4 sts=0 et sw=4 sta' | exe "norm gg=G"
command! RemoveSpaces :%s/\s\+$//e
command! Squish execute "normal \ggVGgq"
command! ClearLastSearch :let @/=""
"}}}

" Copy/Pasta commands{{{
"(`pacman -S gvim` for it)
command! Copy execute 'visual "+y'
command! Pasta execute 'normal "+p'
"}}}

" Text movements (comment if using vim-move){{{
" xnoremap K :move '<-2<CR>gv=gv
" xnoremap J :move '>+1<CR>gv=gv
"}}}

" Menu remaps{{{
nnoremap <leader>qw  :q<CR>
nnoremap <leader>qt  :tabclose<CR>
nnoremap <leader>qq  :qa<CR>
nnoremap <leader>zz  :wa<CR>
nnoremap <leader>zb  :w<CR>
nnoremap <leader>dd  :bdelete<CR>
nnoremap <leader>db  :Bclose<CR>
nnoremap <leader>ds  :bufdo<space>bd<bar>cd<space>$HOME<bar>Startscreen<CR>
nnoremap <leader>r   :%s///gc<Left><Left><Left>
xnoremap <leader>r   :s///gc<Left><Left><Left>
nnoremap <leader>ww  :wincmd w<cr>
nnoremap <leader>wr  :wincmd r<cr>
nnoremap <leader>we  :wincmd =<cr>
nnoremap <leader>wt  :wincmd T<cr>
nnoremap <leader>eg  :!tig<CR>
nnoremap <leader>ett :tabnew<CR>
nnoremap <leader>eto :tabonly<CR>
nnoremap <leader>eww :enew<CR>
nnoremap <leader>ewo :only<CR>
"}}}

" Outofmenu remaps{{{
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <leader>h :help<space>
nnoremap <leader>i <C-a>
vnoremap <leader>i <C-a>
nnoremap <silent>- }}{j
nnoremap <silent>_ {{j
nnoremap <silent><C-h> :vertical resize -5<CR>
nnoremap <silent><C-l> :vertical resize +5<CR>
nnoremap <silent><C-j> :resize -5<CR>
nnoremap <silent><C-k> :resize +5<CR>
nnoremap <leader>wH :wincmd<Space>H<CR>
nnoremap <leader>wL :wincmd<Space>L<CR>
nnoremap <leader>wJ :wincmd<Space>J<CR>
nnoremap <leader>wK :wincmd<Space>K<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nnoremap <leader>0     :tabnext<cr>
nnoremap <silent><C-n> :+tabmove<cr>
nnoremap <silent><C-p> :-tabmove<cr>
"}}}




" command! -nargs=1 ReplaceNormal execute '%s//<args>/gc'
" command! -nargs=1 ReplaceVisual execute 's//<args>/gc'

" remember to check ad set the default web-browser with:
" xdg-settings get default-web-browser
" xdg-settings set default-web-browser brave-browser.desktop

" add support to a plugin for vim-repeat whit the following command:
" silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
" remember to install `xsel` too

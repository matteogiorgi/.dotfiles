" Plugin list{{{
call plug#begin('~/.vim/plugged')
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'matteogiorgi/notewiki'
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
colorscheme dracula  " doom,dracula
filetype plugin indent on
"}}}


" Set mainstuff{{{
set title
set shell=zsh
set runtimepath+=~/.vim_runtime
set nocompatible
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
set nocursorline noerrorbells novisualbell
set splitbelow splitright
set noequalalways
set nofoldenable foldmethod=marker  "zf zd za zo zc zi zE zR zM
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=4000  "default = 4000ms
set timeoutlen=2000  "default = 1000ms
set encoding=UTF-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=  " let &colorcolumn = '81,'.join(range(81,999),',')
set cmdheight=1
" set fillchars+=vert:\ ,eob:\ ,fold:-
set wildchar=<Tab> wildmenu wildmode=full
set laststatus=2 showtabline=2
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
                \ if &number ==? 1 | set relativenumber | endif |
    autocmd WinLeave,BufLeave,FocusLost,InsertEnter *
                \ if &number ==? 1 | set norelativenumber | endif |
augroup end
"}}}


" Simple commands{{{
command! SelectAll execute "normal \ggVG"
command! RemoveSpaces :%s/\s\+$//e
command! ClearLastSearch :let @/=""
command! Copy execute "normal \-r!xclip -o -sel clip"
command! Pasta execute "visual !xclip -f -sel clip"
"}}}

" Simple commands remaps{{{
xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+1<CR>gv=gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <C-h> :vertical resize -5<CR>
nnoremap <C-l> :vertical resize +5<CR>
nnoremap <C-j> :resize -5<CR>
nnoremap <C-k> :resize +5<CR>
nnoremap gr :%s///gc<Left><Left><Left>
xnoremap gr :s///gc<Left><Left><Left>
"}}}




" command! -nargs=1 ReplaceNormal execute '%s//<args>/gc'
" command! -nargs=1 ReplaceVisual execute 's//<args>/gc'

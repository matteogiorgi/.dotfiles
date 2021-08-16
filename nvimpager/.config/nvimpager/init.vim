if exists('+termguicolors') | set termguicolors | endif
if has('linebreak') | let &showbreak='⤷ ' | endif

syntax on
set background=dark
colorscheme doom  " doom,dracula
filetype plugin indent on

set exrc
set title

set nocompatible
set runtimepath+=
set clipboard+=unnamedplus
set nonumber mouse=a
set hlsearch
set incsearch
set encoding=UTF-8
scriptencoding utf-8
set noswapfile
set nobackup
set showmode
set showcmd
set nocursorline
set noerrorbells
set t_Co=256
set scrolloff=999
set sidescrolloff=999
set fillchars+=vert:\ ,eob:\ ,fold:─

highlight! default link EndOfBuffer Normal

nnoremap <silent>j 5<C-e>
nnoremap <silent>k 5<C-y>
nnoremap <silent><M-d> }}{j
nnoremap <silent><M-u> {{j

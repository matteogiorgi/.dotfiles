
"                                  PLUGINS
"                 [ https://github.com/junegunn/vim-plug ]
"
"     autopairs ··············· https://github.com/jiangmiao/auto-pairs
"     vim-surround ············ https://github.com/tpope/vim-surround
"     vim-repeat ·············· https://github.com/tpope/vim-repeat
"     vim-commentary ·········· https://github.com/tpope/vim-commentary
"     vim-fugitive ············ https://github.com/tpope/vim-fugitive
"     vim-smalls ·············· https://github.com/t9md/vim-smalls
"     undotree ················ https://github.com/mbbill/undotree
"     vim-which-key ··········· https://github.com/liuchengxu/vim-which-key
"     vim-fzf ················· https://github.com/junegunn/fzf.vim
"     vim-notewiki ············ https://github.com/matteogiorgi/vim-notewiki
"     vim-pandoc-syntax ······· https://github.com/vim-pandoc/vim-pandoc-syntax




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
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 't9md/vim-smalls'
    Plug 'mbbill/undotree'
    Plug 'liuchengxu/vim-which-key'
    Plug 'junegunn/fzf.vim'
    Plug 'matteogiorgi/vim-notewiki'
    Plug 'vim-pandoc/vim-pandoc-syntax'
call plug#end()
"}}}


" Some settings to load early{{{
if exists('+termguicolors') | set termguicolors | endif
if has('linebreak') | let &showbreak='⤷ ' | endif
if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        execute "!mkdir ~/.vim/undodir"
    endif
    set undodir=$HOME/.vim/undodir
    set undofile
endif
"}}}


" Color syntax{{{
syntax on
set background=dark
colorscheme dracula
filetype plugin indent on
"}}}


" Set mainstuff{{{
set exrc
set title
set shell=zsh  " zsh,bash
set nocompatible
set runtimepath+=~/.vim_runtime  " add whatever
set clipboard=unnamedplus
set number relativenumber mouse=a  " a,n,v,i,c
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
set cursorlineopt=number,line  " number,line
set splitbelow splitright
set equalalways
set nofoldenable foldmethod=marker  "zf zd za zo zc zi zE zR zM
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=300  "default = 4000ms
set timeoutlen=300  "default = 1000ms
set termencoding=utf-8 encoding=utf-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=
set cmdheight=1
set fillchars+=vert:\│,eob:\ ,fold:-
set wildchar=<Tab> wildmenu wildmode=full
set nrformats-=alpha  " alpha,octal,hex,bin,unsigned
set laststatus=2
set showtabline=1
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


" Uncomment for preventing Netrw to load{{{
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
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
    autocmd InsertEnter *
                \ if &filetype !=? 'markdown' && &filetype !=? 'markdown.pandoc' && &filetype !=? 'pandoc' |
                \     let &colorcolumn = '81,'.join(range(81,999),',') |
                \ endif
    autocmd InsertLeave *
                \ if &filetype !=? 'markdown' && &filetype !=? 'markdown.pandoc' && &filetype !=? 'pandoc' |
                \     set colorcolumn= |
                \ endif
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
xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+1<CR>gv=gv
"}}}

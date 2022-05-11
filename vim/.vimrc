
"                                  PLUGINS
"                 [ https://github.com/junegunn/vim-plug ]
"
"     vim-surround ············ https://github.com/tpope/vim-surround
"     vim-repeat ·············· https://github.com/tpope/vim-repeat
"     vim-commentary ·········· https://github.com/tpope/vim-commentary
"     autopairs ··············· https://github.com/jiangmiao/auto-pairs
"     vim-ctrlp ··············· https://github.com/ctrlpvim/ctrlp.vim




" Plug check (it only orks on GNU/Linux){{{
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


" Save last session{{{
augroup vimleave
    autocmd VimLeave *
                \ if !isdirectory('$HOME/.vim/sessions') |
                \     execute "!mkdir -p $HOME/.vim/sessions" |
                \ endif |
                \ mksession! $HOME/.vim/sessions/last
augroup end
"}}}


" Plugin list{{{
call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'jiangmiao/auto-pairs'
    Plug 'ctrlpvim/ctrlp.vim'
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


" Syntax{{{
syntax on
set background=light
colorscheme hemisu
filetype plugin indent on
"}}}


" Set mainstuff{{{
set exrc
set title
set shell=zsh  " zsh,bash
set nocompatible
set esckeys
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
set updatetime=4000  " 300,4000
set timeoutlen=4000  " 300,4000
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
command! Date execute 'r !printf "\n\# " && date && printf "\n"'
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

" Keymaps{{{
xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+1<CR>gv=gv
vnoremap <silent><Tab> >gv
vnoremap <silent><S-Tab> <gv
nnoremap <silent><Left> :tabprevious<CR>
nnoremap <silent><Right> :tabnext<CR>
nnoremap <silent><S-Left> :tabmove -1<cr>
nnoremap <silent><S-Right> :tabmove +1<cr>
nnoremap <silent>Y y$
tnoremap <silent><C-q> <C-\><C-n>
nnoremap <silent><Tab> :wincmd w<cr>
nnoremap <silent><Backspace> :bprevious<cr>
nnoremap <silent><Up> {
nnoremap <silent><Down> }
nnoremap <silent><C-h> :vertical resize -5<CR>
nnoremap <silent><C-l> :vertical resize +5<CR>
nnoremap <silent><C-j> :resize -5<CR>
nnoremap <silent><C-k> :resize +5<CR>
nnoremap <leader>a :Explore<CR>
nnoremap <leader>s :%s///gc<Left><Left><Left>
xnoremap <leader>s :s///gc<Left><Left><Left>
nnoremap <leader>0 0gt
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
"}}}

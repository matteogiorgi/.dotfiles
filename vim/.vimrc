
"                                   PLUGINS
"                  [ https://github.com/junegunn/vim-plug ]
"
"     coc-nvim··················https://github.com/neoclide/coc.nvim
"     vim-snippets··············https://github.com/honza/vim-snippets
"     autopairs·················https://github.com/jiangmiao/auto-pairs
"     vim-surround··············https://github.com/tpope/vim-surround
"     vim-repeat················https://github.com/tpope/vim-repeat
"     vim-commentary············https://github.com/tpope/vim-commentary
"     vim-smalls················https://github.com/t9md/vim-smalls
"     undotree··················https://github.com/mbbill/undotree
"     vim-which-key·············https://github.com/liuchengxu/vim-which-key
"     vim-pandoc-syntax·········https://github.com/vim-pandoc/vim-pandoc-syntax
"     vim-notewiki··············https://github.com/matteogiorgi/vim-notewiki
"     vim-lines·················https://github.com/matteogiorgi/vim-lines
"     vim-startscreen···········https://github.com/matteogiorgi/vim-startscreen




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
    Plug 'honza/vim-snippets'
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 't9md/vim-smalls'
    Plug 'mbbill/undotree'
    Plug 'liuchengxu/vim-which-key'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'matteogiorgi/vim-notewiki'
    Plug 'matteogiorgi/vim-lines'
    Plug 'matteogiorgi/vim-startscreen'
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
colorscheme dracula17
filetype plugin indent on
"}}}


" Set mainstuff{{{
set exrc
set title
set shell=zsh  " zsh,bash
set nocompatible    " nvim is always nocompatible
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
set noequalalways
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


" Uncomment for preventing Netrw to load{{{
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1
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

" Menu remaps{{{
nnoremap <leader>r   :%s///gc<Left><Left><Left>
xnoremap <leader>r   :s///gc<Left><Left><Left>
nnoremap <leader>qq  :quitall<CR>
nnoremap <leader>qQ  :wall<bar>quitall<CR>
nnoremap <leader>bw  :write<CR>
nnoremap <leader>bW  :wall<CR>
nnoremap <leader>bd  :Bclose<CR>
nnoremap <leader>bD  :bdelete<CR>
nnoremap <leader>bn  :enew<CR>
nnoremap <leader>wd  :wincmd q<cr>
nnoremap <leader>wr  :wincmd r<cr>
nnoremap <leader>we  :wincmd =<cr>
nnoremap <leader>wt  :wincmd T<cr>
nnoremap <leader>wnn :enew<cr>
nnoremap <leader>wns :wincmd s<cr>
nnoremap <leader>wnv :wincmd v<cr>
nnoremap <leader>wo  :only<CR>
nnoremap <leader>tt  :tabs<CR>
nnoremap <leader>td  :tabclose<CR>
nnoremap <leader>tn  :tabnew<CR>
nnoremap <leader>to  :tabonly<CR>
"}}}

" Outofmenu remaps{{{
vnoremap <silent><Tab> >gv
vnoremap <silent><S-Tab> <gv
nnoremap <silent><Left> :tabprevious<CR>
nnoremap <silent><Right> :tabnext<CR>
nnoremap <silent><S-Left> :tabmove -1<cr>
nnoremap <silent><S-Right> :tabmove +1<cr>
nnoremap <silent>Y y$
tnoremap <silent><C-q> <C-\><C-n>
tnoremap <silent><C-n> <C-w>w
nnoremap <silent><Up> {
nnoremap <silent><Down> }
nnoremap <silent><C-h> :vertical resize -5<CR>
nnoremap <silent><C-l> :vertical resize +5<CR>
nnoremap <silent><C-j> :resize -5<CR>
nnoremap <silent><C-k> :resize +5<CR>
nnoremap <leader>wH :wincmd<Space>H<CR>
nnoremap <leader>wL :wincmd<Space>L<CR>
nnoremap <leader>wJ :wincmd<Space>J<CR>
nnoremap <leader>wK :wincmd<Space>K<CR>
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
nnoremap <leader>t0 :0tabmove<cr>
nnoremap <leader>t1 :1tabmove<cr>
nnoremap <leader>t2 :2tabmove<cr>
nnoremap <leader>t3 :3tabmove<cr>
nnoremap <leader>t4 :4tabmove<cr>
nnoremap <leader>t5 :5tabmove<cr>
nnoremap <leader>t6 :6tabmove<cr>
nnoremap <leader>t7 :7tabmove<cr>
nnoremap <leader>t8 :8tabmove<cr>
nnoremap <leader>t9 :9tabmove<cr>
nnoremap <silent><C-p> :b#<cr>
nnoremap <silent><C-n> :wincmd w<cr>
"}}}

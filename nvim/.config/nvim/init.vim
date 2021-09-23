
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
"     vim-pandoc-syntax·········https://github.com/vim-pandoc/vim-pandoc-syntax
"     vim-floaterm··············https://github.com/voldikss/vim-floaterm
"     vim-which-key·············https://github.com/liuchengxu/vim-which-key
"     dashboard-nvim············https://github.com/glepnir/dashboard-nvim
"     notewiki··················https://github.com/matteogiorgi/notewiki


"                              LOCAL-PLUGINS 
"
"     lines·····················$HOME/.config/nvim/loplugin/lines
"     bclose····················$HOME/.config/nvim/loplugin/bclose
"     utility···················$HOME/.config/nvim/loplugin/utility
"     painter···················$HOME/.config/nvim/loplugin/painter
"     coq·······················$HOME/.config/nvim/loplugin/coq


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
"     coc-floaterm··············https://github.com/voldikss/coc-floaterm
"     coc-marketplace···········https://github.com/fannheyward/coc-marketplace




" Plug check{{{
augroup vimenter
    autocmd VimEnter *
                \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
                \     PlugInstall --sync | q |
                \ endif
    if !filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
        echo 'Downloading junegunn/vim-plug to manage plugins...'
        silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
                    \ > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
        autocmd VimEnter * PlugInstall
    endif
augroup end
"}}}


" Plugin list{{{
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
    " Remote plugins
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
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'voldikss/vim-floaterm'
    Plug 'liuchengxu/vim-which-key'
    Plug 'glepnir/dashboard-nvim'
    Plug 'matteogiorgi/notewiki'

    " Local plugins
    Plug '~/.config/nvim/loplugin/lines'
    Plug '~/.config/nvim/loplugin/bclose'
    Plug '~/.config/nvim/loplugin/utility'
    Plug '~/.config/nvim/loplugin/painter'
    Plug '~/.config/nvim/loplugin/coq'
call plug#end()
"}}}


" Some settings to load early{{{
if exists('+termguicolors') | set termguicolors | endif
if has('linebreak') | let &showbreak='⤷ ' | endif
if has('persistent_undo')
    set undodir=$HOME/.config/nvim/undodir
    set undofile
endif
"}}}


" Color syntax{{{
syntax on
set background=dark
colorscheme dracula  " doom,dracula,spooky
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
set nocompatible  " nvim is always nocompatible
set runtimepath+=  " add whatever
set clipboard+=unnamedplus
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
set updatetime=300  "default = 4000ms
set timeoutlen=300  "default = 1000ms
set termencoding=utf-8 encoding=utf-8 t_Co=256 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=  " let &colorcolumn = '81,'.join(range(81,999),',')
set signcolumn=auto:2
set cmdheight=1
set fillchars+=vert:\│,eob:\ ,fold:-
set guioptions-=e
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=Hasklig:h8.0
"}}}

" Set completion{{{
set path+=**
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest,noinsert,noselect
set complete+=k/usr/share/dict/british-english
set complete+=k/usr/share/dict/italian
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
                \ if &number ==? 1 | set relativenumber | endif |
                \ if &filetype !=? 'dashboard' | set cursorline | endif
    autocmd WinLeave,BufLeave,FocusLost,InsertEnter *
                \ if &number ==? 1 | set norelativenumber | endif |
                \ set nocursorline
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
nnoremap <leader>dr  :bufdo<space>bd<bar>cd<space>$HOME<bar>Dashboard<CR>
nnoremap <leader>r   :%s///gc<Left><Left><Left>
xnoremap <leader>r   :s///gc<Left><Left><Left>
nnoremap <leader>ww  :wincmd w<cr>
nnoremap <leader>wr  :wincmd r<cr>
nnoremap <leader>we  :wincmd =<cr>
nnoremap <leader>wt  :wincmd T<cr>
nnoremap <leader>ett :tabnew<CR>
nnoremap <leader>eto :only<CR>
nnoremap <leader>eww :enew<CR>
nnoremap <leader>ewo :tabonly<CR>
"}}}

" Outofmenu remaps{{{
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <silent><M-d> }}{j
nnoremap <silent><M-u> {{j
nnoremap <silent><C-h> :vertical resize -5<CR>
nnoremap <silent><C-l> :vertical resize +5<CR>
nnoremap <silent><C-j> :resize -5<CR>
nnoremap <silent><C-k> :resize +5<CR>
nnoremap <silent><M-H> :wincmd<Space>H<CR>
nnoremap <silent><M-L> :wincmd<Space>L<CR>
nnoremap <silent><M-J> :wincmd<Space>J<CR>
nnoremap <silent><M-K> :wincmd<Space>K<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nnoremap <leader>0 0gt
nnoremap <silent><M-Tab>       :tabnext<cr>
nnoremap <silent><M-Backspace> :tabprev<cr>
nnoremap <silent><M-C-h>       :tabm -1<cr>
nnoremap <silent><M-C-l>       :tabm +1<cr>
"}}}




" remember to check ad set the default web-browser with:
" xdg-settings get default-web-browser
" xdg-settings set default-web-browser brave-browser.desktop

" add support to a plugin for vim-repeat whit the following command:
" silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
" remember to install `xsel` too

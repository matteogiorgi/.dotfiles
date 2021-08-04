" Set statusline{{{
set laststatus=2
set statusline=
set statusline+=%{statusline#Spaces(1)}
set statusline+=%{statusline#StatuslineGit()}
set statusline+=%{statusline#Path()}  " set statusline+=%f
set statusline+=%{statusline#Spaces(1)}
set statusline+=%{statusline#BufferStatus()}
set statusline+=%=
set statusline+=%{statusline#LineInfo()}
if &rtp =~ 'coc.nvim'
    set statusline+=%{statusline#Spaces(1)}
    set statusline+=--
    set statusline+=%{statusline#Spaces(1)}
    set statusline+=%{statusline#LinePercent()}
    set statusline+=%{statusline#Spaces(10)}
    set statusline+=%{statusline#CocStatus()}
else
    set statusline+=%{statusline#Spaces(10)}
    set statusline+=%{statusline#LinePercent()}
endif
set statusline+=%{statusline#Spaces(1)}
"}}}

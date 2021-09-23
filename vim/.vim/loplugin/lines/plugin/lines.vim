" Set statusline{{{
set laststatus=2
set statusline=
set statusline+=%{lines#Spaces(1)}
set statusline+=%{lines#StatuslineGit()}
set statusline+=%{lines#Path()}  " set statusline+=%f
set statusline+=%{lines#Spaces(1)}
set statusline+=%{lines#BufferStatus()}
set statusline+=%=
set statusline+=%{lines#LineInfo()}
if &rtp =~ 'coc.nvim'
    set statusline+=%{lines#Spaces(1)}
    set statusline+=--
    set statusline+=%{lines#Spaces(1)}
    set statusline+=%{lines#LinePercent()}
    set statusline+=%{lines#Spaces(10)}
    set statusline+=%{lines#CocStatus()}
else
    set statusline+=%{lines#Spaces(10)}
    set statusline+=%{lines#LinePercent()}
endif
set statusline+=%{lines#Spaces(1)}
"}}}


" Set tabline{{{
set showtabline=2
set tabline=%!lines#TabStatus()
"}}}

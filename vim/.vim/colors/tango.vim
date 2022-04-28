set background=dark
highlight clear

let g:colors_name="tango"
if exists("syntax_on")
    syntax reset
endif

highlight Normal guibg=#2e3436 guifg=#d3d7cf

" {{{ syntax
highlight Comment    guifg=#555753
highlight Title      guifg=#eeeeec
highlight Underlined guifg=#20b0eF gui=none
highlight Statement  guifg=#888a85
highlight Type	     guifg=#ce5c00
highlight PreProc    guifg=#eeeeec
highlight Constant	 guifg=#babdb6
highlight Identifier guifg=#ce5c00
highlight Special    guifg=#eeeeec
highlight Ignore     guifg=#f57900
highlight Todo	     guibg=#ce5c00 guifg=#eeeeec
"}}}

" {{{ groups
highlight Directory    guifg=#bbd0df
highlight VertSplit    guibg=#555753 guifg=#2e3436 gui=none
highlight Folded       guibg=#555753 guifg=#eeeeec
highlight FoldColumn   guibg=#2e3436 guifg=#555753
highlight LineNr       guibg=#2e3436 guifg=#555753
highlight ModeMsg      guifg=#ce5c00
highlight NonText      guibg=#2e3436 guifg=#555753
highlight Question     guifg=#aabbcc
highlight Search       guibg=#fce94f guifg=#2e3436
highlight IncSearch    guibg=#c4a000 guifg=#fce94f
highlight SpecialKey   guifg=#ce5c00
highlight StatusLine   guibg=#555753 guifg=#eeeeec gui=bold cterm=bold
highlight StatusLineNC guibg=#555753 guifg=#eeeeec gui=none cterm=none
highlight TabLine      guibg=#555753 guifg=#eeeeec gui=none cterm=none
highlight TabLineSel   guibg=#555753 guifg=#eeeeec gui=bold cterm=bold
highlight TabLineFill  guibg=#555753 guifg=#555753
highlight Visual       guibg=#232829
highlight WarningMsg   guifg=salmon
highlight Pmenu        guibg=#babdb6 guifg=#555753
highlight PmenuSel     guibg=#eeeeec guifg=#2e3436
highlight CursorLine   guibg=#232829 gui=none cterm=none
highlight CursorLineNr guibg=#2e3436 guifg=#555753 gui=bold cterm=bold
highlight ColorColumn  guibg=#232829
" }}}

" highlight Cursor       guibg=#babdb6 guifg=#2e3436
" highlight MatchParen   guibg=#babdb6 guifg=#2e3436

"vim: sw=4

" Vim color file
" Maintainer:  Matteo Giorgi <matteo.giorgi@protonmail.com>
" Last Change: 2022 May 06

" This is more or less the default color scheme.
" It doesn't define the Normal highlighting, it uses whatever the colors used to be.


" Set 'background' back to the default.
" The value can't always be estimated and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
highlight clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
    syntax reset
endif

let colors_name = "vanilla"

hi VertSplit    gui=none cterm=none
hi CursorLine   gui=none cterm=none
hi CursorLineNr gui=bold cterm=bold
hi TabLine      gui=none cterm=none
hi TabLineSel   gui=bold cterm=bold

hi! link ColorColumn CursorLine

" vim: ts=4 sw=4

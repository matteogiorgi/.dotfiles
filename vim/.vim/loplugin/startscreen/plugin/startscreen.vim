" vim: set sw=2 ts=2 sts=2 et
"
" Plugin:      https://github.com/haomingw/vim-startscreen
" Description: A simple start screen for Vim.
" Maintainer:  Haoming Wang <http://github.com/haomingw>

if exists('g:loaded_startscreen') || &cp
  finish
endif
let g:loaded_startscreen = 1
let s:save_cpo = &cpo
set cpo&vim

augroup startscreen
  autocmd!
  autocmd VimEnter * call startscreen#start()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

let g:startscreen_custom_header = [
      \ '                                                                     ',
      \ '                                                                     ',
      \ '            :h-                                  Nhy`                ',
      \ '           -mh.                           h.    `Ndho                ',
      \ '           hmh+                          oNm.   oNdhh                ',
      \ '          `Nmhd`                        /NNmd  /NNhhd                ',
      \ '          -NNhhy                      `hMNmmm`+NNdhhh                ',
      \ '          .NNmhhs              ```....`..-:/./mNdhhh+                ',
      \ '           mNNdhhh-     `.-::///+++////++//:--.`-/sd`                ',
      \ '           oNNNdhhdo..://++//++++++/+++//++///++/-.`                 ',
      \ '      y.   `mNNNmhhhdy+/++++//+/////++//+++///++////-` `/oos:        ',
      \ ' .    Nmy:  :NNNNmhhhhdy+/++/+++///:.....--:////+++///:.`:s+         ',
      \ ' h-   dNmNmy oNNNNNdhhhhy:/+/+++/-         ---:/+++//++//.`          ',
      \ ' hd+` -NNNy`./dNNNNNhhhh+-://///    -+oo:`  ::-:+////++///:`         ',
      \ ' /Nmhs+oss-:++/dNNNmhho:--::///    /mmmmmo  ../-///++///////.        ',
      \ '  oNNdhhhhhhhs//osso/:---:::///    /yyyyso  ..o+-//////////:/.       ',
      \ '   /mNNNmdhhhh/://+///::://////     -:::- ..+sy+:////////::/:/.      ',
      \ '     /hNNNdhhs--:/+++////++/////.      ..-/yhhs-/////////::/::/`     ',
      \ '       .ooo+/-::::/+///////++++//-/ossyyhhhhs/:///////:::/::::/:     ',
      \ '       -///:::::::////++///+++/////:/+ooo+/::///////.::://::---+`    ',
      \ '       /////+//++++/////+////-..//////////::-:::--`.:///:---:::/:    ',
      \ '       //+++//++++++////+++///::--                 .::::-------::    ',
      \ '       :/++++///////////++++//////.                -:/:----::../-    ',
      \ '       -/++++//++///+//////////////               .::::---:::-.+`    ',
      \ '       `////////////////////////////:.            --::-----...-/     ',
      \ '        -///://////////////////////::::-..      :-:-:-..-::.`.+`     ',
      \ '         :/://///:///::://::://::::::/:::::::-:---::-.-....``/- -    ',
      \ '           ::::://::://::::::::::::::----------..-:....`.../- -+oo/  ',
      \ '            -/:::-:::::---://:-::-::::----::---.-.......`-/.      `` ',
      \ '           s-`::--:::------:////----:---.-:::...-.....`./:           ',
      \ '          yMNy.`::-.--::..-dmmhhhs-..-.-.......`.....-/:`            ',
      \ '         oMNNNh. `-::--...:NNNdhhh/.--.`..``.......:/-               ',
      \ '        :dy+:`      .-::-..NNNhhd+``..`...````.-::-`                 ',
      \ '                        .-:mNdhh:.......--::::-`                     ',
      \ '                           yNh/..------..`                           ',
      \ '                                                                     ',
      \ '                                                                     ',
      \ '                           E V I L · V I M                           ',
      \ '                                                                     ',
      \ '                                                                     ',
      \ '            [S]essions · [R]ecents · [F]iles · [N]otewiki            ',
      \ '                                                                     ',
      \ '                                                                     ',
      \ ]



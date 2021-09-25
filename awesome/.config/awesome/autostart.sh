#! /usr/bin/env bash

# demons
picom &
~/.fehbg &
nm-applet &
blueman-applet &

# programs
setxkbmap -layout gb
xmodmap ~/.Xmodmap
emacs --daemon

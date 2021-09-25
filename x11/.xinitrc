#!/bin/sh

# This is just the xinitrc file to use as argument for startx if you don't have
# a login manager. It only launches Awesome (exec awesome) becouse allthe startup
# programs are taken care in autorun.sh or directly at the bottom of rc.lua.

xrdb -load ~/.Xresources &
xsettingsd &
/usr/bin/awesome start

#!/bin/sh

# This is just the xinitrc file to use as argument for startx if you don't have
# a login manager. It only launches bspwm (exec bspwm) becouse all the startup
# programs are taken care in ~/.config/bspwm/bspwmrc.

xrdb -load ~/.Xresources &
xsettingsd &
/usr/bin/bspwm start

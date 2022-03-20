#!/bin/sh

# This is just the xinitrc file to use as argument for startx if you don't have
# a login manager. It only launches bspwm (`exec bspwm` or `/usr/bin/bspwm start`)
# because all the startup programs are taken care in ~/.config/bspwm/bspwmrc.




## LOAD SHIT
############

xrdb -load ~/.Xresources &
xsettingsd &
systemctl --user import-environment DISPLAY




## START WM
###########

if [[ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -eq 2 ]]; then
    exec herbstluftwm 2>~/.wm.err
else
    exec berry 2>~/.wm.err
fi

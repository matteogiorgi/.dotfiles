#!/bin/sh

# This is just the xinitrc file to use as argument for startx if you don't have
# a login manager. It only launches LeftWM (exec leftwm) becouse allthe startup
# programs are taken care in ~/.config/leftwm/themes/current/up.

xrdb -load ~/.Xresources &
xsettingsd &
exec dbus-launch leftwm

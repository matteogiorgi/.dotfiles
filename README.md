# Dotfiles (I'm using BSPWM nowadays!)

These repo contains my major dotfiles. I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and it's sweet, [click clack](https://matteogiorgi.github.io/config.html) for more info.




## Mouse conf

Write `/etc/X11/xorg.conf.d/10-synaptics.conf` with the following settings:

```
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "VertEdgeScroll" "off"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "off"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "1"
EndSection
```




## Tools

- bspwm + polybar + picom (window manager)
- sxhkd + touchcursor (fancy keymaps)
- st + alacritty + xerm (terminal emulator)
- amp + vim + geany (text editor)
- bash + zsh (bourne again shell)
- fzf + broot (fuzzy finder)
- vimpager + bat (glorified more & cat)
- zathura + sxiv (document & image viewer)
- dmenu + slock (suckless menu & lockscreen)
- tmux (terminal multiplexer)
- tig (git client)

<!-- -->

- pamixer + pavucontrol (pulseaudio command-line mixer)
- xorg-xrandr + arandr (interface to RandR extension)
- xorg-xrdb + xorg-xmodmap (menage Xresources & Xmodmap)
- xsettingsd + xdotool + xdo (x11 tools)
- feh + imagemagick (image manipulation)
- networkmanager + blueman (manage connections)
- git + delta (distributed version control)
- curl + lftp (file transfer)
- ripgrep + exa + bottom (rust utils)
- pandoc + texlive-most (document manipulation)
- lxappearence + qt5ct (theme switcher)
- vlc + id3v2 (media player)
- xournalpp + calcurse (notes & agenda)
- pcmanfm (file manager)
- brave (web browser)

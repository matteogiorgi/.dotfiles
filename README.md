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




## Wacom conf

Just fire the following command once the tablet is connected:

```
xinput map-to-output <xinput-id> <xrandr-output>
```




## Necessary tools

- sxhkd (keybinder)
- polybar (desktop bar)
- picom (compositor effects)
- feh (img viewer and wallpaper setter)
- networkmanager (for network-manager-applet)
- blueman (for blueman-applet)
- xorg-xrdb (load Xresources)
- xorg-xmodmap (run Xmodmap)
- xsettingsd (xsettings deamon)
- xdotool (command-line X11 automation tool)
- xorg-xrandr (cli interface to RandR extension)
- xdo (utility for performing action on windows)
- imagemagick (image manipulation program)
- pamixer (pulseaudio command-line mixer)
- nodejs (js runtime environment)
- texlive-most (document preparation)
- pandoc (document converter)
- ripgrep (recursive search tool)
- git (distributed version control)
- curl (URL transfer)
- lftp (file transfer)
- cargo (rust package manager)




### Core utility programs (already preconfigured)

- dmenu (suckless menu)
- slock (suckless lockscreen)
- bash (bourne again shell)
- zsh (extended bourne shell)
- st (suckless terminal emulator)
- alacritty (rust terminal emulator)
- xterm (x11 terminal emulator)
- vim (vi improved)
- amp (rust vi-like editor)
- shfm (file manager in posix shell)
- broot (rust file navigator)
- fzf (fuzzy finder)
- tmux (terminal multiplexer)
- vimpager (vim as pager)
- bat (glorified cat)
- tig (git client)
- touchcursor (fancy keymaps)
- zathura (document viewer)
- sxiv (image viewer)




### Other useful programs (no config needed)

- arandr (gui xrandr interface)
- pavucontrol (gui pulsaudio volume control)
- lxappearence (gui gtk theme switcher)
- qt5ct (gui qt5 theme switcher)
- pcmanfm (gui file manager)
- xarchiver (gui archive manager)
- vlc (gui video/music player)
- brave (gui web browser)
- vscode (all in one ide)
- xournalpp (note-taker)
- mplayer (media player)
- id3v2 (media labeller)
- sc-im (spreadsheet editor)
- calcurse (agenda)
- bottom (top on steroids)
- delta (git pager)

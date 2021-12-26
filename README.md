# Dotfiles

These repo contains my major dotfiles. I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and it's sweet, [click clack](https://matteogiorgi.github.io/config.html) for more info.




## I'm using BSPWM nowadays!

Remember to write `/etc/X11/xorg.conf.d/10-synaptics.conf` with the following settings:

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




### Necessary tools

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
- curl, lftp (data transfer)




### lang package managers

- npm
- python-pip
- cargo




### Core utility programs (already preconfigured)

- dmenu (suckless menu)
- slock (suckless lockscreen)
- zsh, bash (shell)
- st, alacritty, xterm (terminal emulator)
- vim, amp (text editors)
- shfm, broot, fzf (file explorer)
- tmux (terminal multiplexer)
- vimpager (pager)
- bat (glorified cat)
- tig (git client)
- touchcursor (fancy keymaps)
- zathura (document viewer)
- sxiv (image viewer)




### Other useful programs (no config needed)

- arandr (gui xrandr interface)
- pavucontrol (gui pulsaudio volume control)
- lxappearence, qt5ct (gui gtk/qt5 theme switcher)
- pcmanfm, xarchiver (gui file/archive manager)
- vlc (gui video/music player)
- brave (gui web browser)
- vscode (all in one ide)
- xournalpp (note-taker)
- mplayer, id3v2 (media player/labeller)
- sc-im (spreadsheet editor)
- calcurse (agenda)
- bottom (top on steroids)

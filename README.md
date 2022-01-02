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




## Tools

- bspwm + sxhkd + polybar + picom (window manager)
- pamixer + pavucontrol (pulseaudio command-line mixer)
- xorg-xrandr + arandr (interface to RandR extension)
- xorg-xrdb (load Xresources)
- xorg-xmodmap (run Xmodmap)
- xsettingsd (xsettings deamon)
- xdotool (command-line X11 automation tool)
- xdo (utility for performing action on windows)
- feh + imagemagick (image manipulation)
- networkmanager (to manage networks)
- blueman (to manage bt connections)
- git + delta (distributed version control)
- curl + lftp (file transfer)
- ripgrep (recursive search tool)
- exa (ls on steroids)
- pandoc (document converter)
- texlive-most (document preparation)
- cargo (we all need some rust)

<!-- -->

- dmenu (suckless menu)
- slock (suckless lockscreen)
- st + alacritty + xerm (terminal emulator)
- bash + zsh (bourne again shell)
- amp + vim + vimpager (tui text editor)
- tmux (terminal multiplexer)
- tig (tui git client)
- fzf + broot (fuzzy finder)
- bat (glorified cat)
- touchcursor (fancy keymaps)
- zathura (document viewer)
- sxiv (image viewer)

<!-- -->

- lxappearence + qt5ct (gui theme switcher)
- pcmanfm (gui file manager)
- brave (gui web browser)
- xournalpp (gui note-taker)
- vscode + vspcecode (gui text editor)
- mplayer + id3v2 (media player)
- calcurse (agenda)
- bottom (top on steroids)

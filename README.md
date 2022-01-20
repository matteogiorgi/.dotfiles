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

- bspwm           (window manager)
- polybar         (statusbar)
- dmenu           (suckless menu)
- picom           (compositor)
- slock           (simple lock)
- sxhkd           (keybindings)
- touchcursor     (fancy keycords)
- st              (simple terminal)
- alacritty       (rust terminal)
- xerm            (x11 terminal)
- vim             (THE text editor)
- amp             (rust text editor)
- geany           (gui text editor)
- bash            (bourne again shell)
- zsh             (bash on steroids)
- fzf             (fuzzy finder)
- broot           (rust fuzzy finder)
- vimpager        (glorified more)
- bat             (glorified cat)
- zathura         (document viewer)
- sxiv            (image viewer)
- tmux            (terminal multiplexer)
- tig             (git client)

<!-- -->

- pamixer         (pulseaudio command-line mixer)
- pavucontrol     (gui pulseaudio interface)
- xorg-xrandr     (interface to RandR extension)
- arandr          (gui xrandr interface)
- xorg-xrdb       (menage Xresources)
- xorg-xmodmap    (menage Xmodmap)
- xsettingsd      (x11 application settings)
- xdotool         (x11 automation tool)
- xdo             (perform action on windows)
- feh             (image viewer)
- imagemagick     (image manipulation)
- networkmanager  (network connections)
- blueman         (bluetooth connections)
- git             (version control)
- delta           (git pager)
- ripgrep         (better grep in rust)
- exa             (better ls in rust)
- bottom          (better htop in rust)
- pandoc          (markup converter)
- texlive         (document formatter)
- lxappearence    (gtk appearance)
- qt5ct           (qt appearance)
- vlc             (media player)
- calcurse        (calendar/agenda)
- xournalpp       (handwritten notes)
- pcmanfm         (file manager)
- xarchiver       (archive manager)
- brave           (web browser)

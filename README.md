# Dotfiles (I'm using Herbstluftwm nowadays)

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




## Tools I use

- herbstluftwm    (window manager)
- touchcursor     (fancy keycords)
- polybar         (statusbar)
- picom           (compositor)
- dmenu           (suckless menu)
- slock           (suckless lock)

- st              (suckless terminal)
- alacritty       (rust terminal)
- (u)xterm        (x11 terminal)

- vim             (THE text editor)
- amp             (rust text editor)
- geany           (gui text editor)

- bash            (bourne again shell)
- zsh             (bash on steroids)

- fzf             (go fuzzy finder)
- broot           (rust fuzzy finder)

- shfm            (simple file manager)
- qtfm            (gui file manager)

- vimpager        (glorified more)
- bat             (glorified cat)
- exa             (rust ls)
- lfs             (rust df)

- mpv             (media player)
- zathura         (document viewer)
- sxiv            (image viewer)

- tmux            (terminal multiplexer)
- tig             (git client)
- bottom          (rust htop)
- calcurse        (calendar/agenda)
- atool           (archive manager)

- xournalpp       (note taker)
- brave           (web browser)

- lxappearence    (gtk appearance)
- qt5ct           (qt appearance)
- pavucontrol     (gui pulseaudio interface)
- arandr          (gui xrandr interface)
- networkmanager  (network connections)
- blueman         (bluetooth connections)
- kalu            (keep arch linux uptodate)
- kupfer          (gui menu-launcher)


## Utilities I need

- pamixer         (pulseaudio command-line mixer)
- xorg-xrandr     (interface to RandR extension)
- autorandr       (automatically select display)
- xorg-xrdb       (menage Xresources)
- xorg-xmodmap    (menage Xmodmap)
- xsettingsd      (x11 application settings)
- xdotool         (x11 automation tool)
- xdo             (perform action on windows)
- feh             (image viewer)
- imagemagick     (image manipulation)
- git             (version control)
- delta           (git pager)
- ripgrep         (better grep in rust)
- pandoc          (markup converter)
- texlive         (document formatter)
- cups            (printing system)

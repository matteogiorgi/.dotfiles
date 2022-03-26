# Dotfiles (I'm using Herbstluftwm & LXQT nowadays)

These repo contains my major dotfiles. I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and it's sweet, [click clack](https://matteogiorgi.github.io/config.html) for more info.



## Display manager

Run `systemctl enable ly.service` to enable the ly display manager.




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

- ly              (tui display manager)
- LXQT            (minimal desktop environment)
- herbstluftwm    (tiling window-manager)
- sxhkd           (independent keybindings)
- touchcursor     (keyboard remap keybindings)
- polybar         (statusbar)
- picom           (compositor)
- dunst           (notification daemon)
- dmenu           (suckless menu)
- slock           (suckless lock)

<!-- -->

- st              (suckless terminal)
- alacritty       (rust terminal)
- (u)xterm        (x11 terminal)

<!-- -->

- kitty           (terminal emulator & multiplexer)
- tmux            (terminal multiplexer)

<!-- -->

- vim             (THE text editor)
- amp             (rust text editor)
- xed             (gui text editor)
- vscode          (electron text editor)

<!-- -->

- bash            (bourne again shell)
- zsh             (bash on steroids)

<!-- -->

- fzf             (go fuzzy finder)
- broot           (rust fuzzy finder)

<!-- -->

- rover           (simple file manager)
- shfm            (sh file manager)
- qtfm            (qt file manager)

<!-- -->

- vimpager        (glorified more)
- bat             (glorified cat)
- exa             (rust ls)
- lfs             (rust df)

<!-- -->

- mpv             (media player)
- zathura         (document viewer)
- sxiv            (image viewer)

<!-- -->

- tig             (git client)
- bottom          (rust htop)
- calcurse        (calendar/agenda)
- atool           (archive manager)

<!-- -->

- texlive         (document formatter)
- pandoc          (markup converter) [panflute]
- slides          (tui presentation) [perl-graph-easy]

<!-- -->

- brave           (chromium web-browser) [vimium, media-player, draw-on-page]
- firefox         (mozilla web-browser) [ublock-origin]
- ferdi           (web-app container)

<!-- -->

- xournalpp       (note taker)
- flameshot       (screenshot tool)
- obs-studio      (video recorder)
- gimp            (image manipulation)

<!-- -->

- lxappearence    (gtk appearance)
- qt5ct           (qt appearance)
- pavucontrol     (gui pulseaudio interface)
- arandr          (gui xrandr interface)
- networkmanager  (network connections)
- blueman         (bluetooth connections)
- cups            (printing system)
- kalu            (keep arch linux updated)
- kupfer          (menu launcher)


## Utilities I need

- pamixer         (pulseaudio command-line mixer)
- xorg-xrandr     (interface to RandR extension) [autorandr]
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

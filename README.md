# Dotfiles (I'm using Herbstluftwm nowadays)

These repo contains my major dotfiles. I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and it's sweet, [click clack](https://matteogiorgi.github.io/config.html) for more info.



## Display manager

First disable your current display-manager with something like `systemctl disable lightdm.service`, then run `systemctl enable ly.service` to enable the ly display manager.




## Mouse conf

Just run the following (with super user privileges):

```
cat > /etc/X11/xorg.conf.d/10-synaptics.conf <<-EOF
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
EOF
```




## Workflow utilities


### X11 and window-manager related gear

- ly              (tui display manager)
- herbstluftwm    (tiling window-manager)
- sxhkd           (independent keybindings)
- polybar         (statusbar)
- picom           (compositor)
- dunst           (notification daemon)
- dmenu           (suckless menu)
- slock           (suckless lock)
- paru            (aur package manager - rust made)
- pip             (python package manager) `curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10`
- cargo           (rust package manager)


### Terminal emulators

- st              (suckless terminal)
- alacritty       (rustmade terminal)
- (u)xterm        (x11 terminal)
- kitty           (fast terminal emulator)


### Text editors

- amp             (rustmade text editor)
- vim             (THE true text editor)
- kakoune         (new age modal text editor)
- vscode          (electron editor/ide)


### Shells

- bash            (bourne again shell)
- zsh             (bash on steroids)
- xonsh           (python powered shell) `python -m pip install 'xonsh[full]'`
- tmux            (terminal multiplexer)


### File managers and fuzzy finders

- fzf             (go fuzzy finder)
- broot           (rust fuzzy finder and file manager)
- rover           (simple file manager)


### Enhanced utilities

- vimpager        (glorified more)
- bat             (glorified cat)
- exa             (rust ls)
- lfs             (rust df)


### Other useful utilities

- tig             (git client)
- bottom          (rust htop)
- calcurse        (calendar/agenda)
- atool           (archive manager)


### Document manipulation programs

- texlive         (document formatter)
- pandoc          (markup converter) [panflute]
- slides          (tui presentation) [perl-graph-easy]


### Media readers

- mpv             (media player)
- zathura         (document viewer)
- sxiv            (image viewer)


### Media tools

- xournalpp       (note taker)
- flameshot       (screenshot tool)
- simplescreen    (video recorder)


### Browsers (vscode should have been here)

- brave           (chromium web-browser) [media-player, draw-on-page]
- firefox         (mozilla web-browser) [ublock-origin]


### Very useful gui programs

- lxappearence    (gtk appearance)
- qt5ct           (qt appearance)
- pavucontrol     (gui pulseaudio interface)
- arandr          (gui xrandr interface)
- networkmanager  (network connections)
- blueman         (bluetooth connections)
- cups            (printing system)
- kalu            (keep arch linux updated)




## Behind the curtains utilities

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

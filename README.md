# Dotfiles

These repo contains my major dotfiles. I keep them organized using [GNU Stow](https://www.gnu.org/software/stow/) and it's sweet, [click clack](https://matteogiorgi.github.io/config.html) for more info. After trying tonnes of window managers, I've settled with [Herbstluftwm](https://herbstluftwm.org/) as my primary choice, usually together with vanilla Gnome (there's no need of `gnome-extra` but remember to install `dconf-editor`, it's quite usefull when it comes of dealing gnome confs). I like my system clean and minimal, so the scripts are in good order and well readable but there wont be no more than the bare essentials.

Below there is a list of utilities usefull in everyday life, a detailed documentation and installer-script will come soon.



## Display manager

In order to use the *ly* display-manager, first disable your current display-manager with something like `systemctl disable lightdm.service`, then run `systemctl enable ly.service` to enable the *ly* display-manager.




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

- herbstluftwm (tiling window-manager)
- sxhkd        (independent keybindings)
- polybar      (statusbar)
- dmenu        (suckless menu)
- slock        (suckless lock)
- paru         (aur package manager)


### Terminal emulators

- st        (suckless terminal)
- alacritty (rustmade terminal)
- (u)xterm  (x11 terminal)


### Terminal multiplexer

- kitty (fast terminal emulator)
- tmux  (terminal multiplexer)


### Text editors

- amp  (rustmade text editor)
- vim  (THE true text editor)
- code (electron editor/ide)


### Shells and terminal multiplexers

- bash  (bourne again shell)
- zsh   (bash on steroids) [zsh-syntax-highlighting]
- xonsh (python powered shell) `python -m pip install 'xonsh[full]'`


### File managers and fuzzy finders

- shfm  (fast file opener)
- rover (simple file manager)
- fzf   (go fuzzy finder)


### Enhanced optional utilities

- bat      (glorified cat)
- vimpager (why not)
- bottom   (rust htop)
- exa      (rust ls)
- lfs      (rust df)
- ripgrep  (rust grep)


### Other very useful utilities

- git       (version control)
- tig       (git client)
- atool     (archive manager)
- trash-cli (trash utility)
- calcurse  (calendar/agenda)


### Document manipulation programs

- texlive (document formatter)
- pandoc  (markup converter) [panflute]
- slides  (tui presentation) [perl-graph-easy]


### Media readers

- mpv     (media player)
- zathura (document viewer)
- sxiv    (image viewer)


### Media tools

- xournalpp    (note taker)
- flameshot    (screenshot tool)
- simplescreen (video recorder)


### Browsers

- librewolf (firefox-based web-browser)
- brave     (chromium-based web-browser) [media-player]
- vieb      (vim-like electron-based browser)


### Very useful gui programs

- lxappearence   (gtk appearance)
- qt5ct          (qt appearance)
- pavucontrol    (gui pulseaudio interface)
- arandr         (gui xrandr interface)
- networkmanager (network connections)
- blueman        (bluetooth connections)
- cups           (printing system)
- stow           (symlink manager)


### Other stuff

- pamixer            (pulseaudio command-line mixer)
- xorg-xrandr        (interface to RandR extension) [autorandr]
- xorg-xrdb          (menage Xresources)
- xorg-xmodmap       (menage Xmodmap)
- xsettingsd         (x11 application settings)
- xdotool            (x11 automation tool)
- xdo                (perform action on windows)
- feh                (image viewer)
- imagemagick        (image manipulation)
- bluez              (bluetooth shit) [bluez-utils]
- gnome-themes-extra (extra themes for gnome)
- adwaita-qt         (qt5 adwaita look-a-like)
- adwaita-icon-theme (gnome standard icons)

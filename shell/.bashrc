######################################################
#                      BASH CONF                     #
######################################################




# If not running interactively, don't do anything
[[ $- != *i* ]] && return




### Set Colors to use in in the script
######################################

# Normal Colors
Black='\[\e[0;30m\]'	# Black
Red='\[\e[0;31m\]'		# Red
Green='\[\e[0;32m\]'	# Green
Yellow='\[\e[0;33m\]'	# Yellow
Blue='\[\e[0;34m\]'		# Blue
Purple='\[\e[0;35m\]'	# Purple
Cyan='\[\e[0;36m\]'		# Cyan
White='\[\e[0;37m\]'	# White

# Bold
BBlack='\[\e[1;30m\]'	# Black
BRed='\[\e[1;31m\]'		# Red
BGreen='\[\e[1;32m\]'	# Green
BYellow='\[\e[1;33m\]'	# Yellow
BBlue='\[\e[1;34m\]'	# Blue
BPurple='\[\e[1;35m\]'	# Purple
BCyan='\[\e[1;36m\]'	# Cyan
BWhite='\[\e[1;37m\]'	# White

# Background
On_Black='\[\e[40m\]'	# Black
On_Red='\[\e[41m\]'		# Red
On_Green='\[\e[42m\]'	# Green
On_Yellow='\[\e[43m\]'	# Yellow
On_Blue='\[\e[44m\]'	# Blue
On_Purple='\[\e[45m\]'	# Purple
On_Cyan='\[\e[46m\]'	# Cyan
On_White='\[\e[47m\]'	# White

NC='\[\e[m\]'			# Color Reset

ALERT="${BWhite}${On_Red}" # Bold White on red background




### Environment variables (remember to install vim, brave, zathura)
###################################################################

export PAGER="less" && [[ -f /bin/vimpager ]] && export PAGER="vimpager"
export MANPAGER="less" && [[ -f /bin/vimpager ]] && export MANPAGER="vimpager"
[[ -f /bin/vim ]] && export VISUAL="vim"
[[ -f /bin/vim ]] && export EDITOR="vim"
[[ -f /bin/brave ]] && export BROWSER="brave"
[[ -f /bin/zathura ]] && export READER="zathura"

# possible $TERM values are: xterm-kitty, xterm-256color or screen-256color
export TERM="xterm-256color"

# special Haskell exports (curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh)
export GHCUP_BIN="$HOME/.ghcup/bin"
export CABAL_BIN="$HOME/.cabal/bin"

# other special exports
export EMACS_BIN="$HOME/.emacs.d/bin"
export CARGO_BIN="$HOME/.cargo/bin"
export GOPATH_BIN="$HOME/go/bin"

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively (simpler one: PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}")
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$EMACS_BIN:$GHCUP_BIN:$CABAL_BIN:$CARGO_BIN:$GOPATH_BIN"

# better do not export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#171421,bg:#ffffff,hl:#12488B --color=fg+:#171421,bg+:#d0cfcc,hl+:#2A7BDE'
export FZF_ALT_C_COMMAND='/bin/ls -ap . | grep -E "/$" | tr -d "/"'
export FZF_CTRL_T_COMMAND='rg --files --hidden -g "!.git" 2>/dev/null'

# FFF exports
export FFF_OPENER="swallow"
export FFF_TRASH_CMD="trash"

# set file opener
export OPEN='swallow'




### Source plugins
##################

[[ -f $HOME/Pictures/wallpapers/src ]] && source $HOME/Pictures/wallpapers/src




### Source some shit
#####################

# fm6000, pfetch or ufetch
[[ -f $HOME/bin/pfetch ]] && $HOME/bin/pfetch

# fzf
[[ -f $HOME/.fzf.bash ]] && source $HOME/.fzf.bash
[[ -f $HOME/.config/fzf/completion.bash ]] && source $HOME/.config/fzf/completion.bash
[[ -f $HOME/.config/fzf/key-bindings.bash ]] && source $HOME/.config/fzf/key-bindings.bash




### Set prompt
##############

PS1="${Yellow}\u@\h${NC}: ${Blue}\w${NC} \\$ "




### Set common functions
########################

# Creates an archive (*.tar.gz) from given directory (better to use atool anyway)
function maketar () { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/" ; }

# Create a ZIP archive of a file or folder (better to use atool anyway)
function makezip () { zip -r "${1%%/}.zip" "$1" ; }

# enable/disable touchpad
function xtouchpad () {
    if (( $# == 0 )); then
        echo "specify if you want to enable (1) or disable (0) your touchpad"
        return
    fi
    TOUCH=$(xinput | grep Touchpad | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    [[ $TOUCH == "" ]] && TOUCH=$(xinput | grep TouchPad | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    xinput set-prop $TOUCH "Device Enabled" $1
}

# Set input to a single monitor (check output monitor with xrandr)
function xwacom-output () {
    local MONITOR=$(xrandr --query | grep " connected" | awk 'NR==1 {print $1}')
    if [[ $(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l) -eq 2 ]]; then
        [[ $1 -eq 2 ]] && MONITOR=$(xrandr --query | grep " connected" | awk 'NR==2 {print $1}')
    fi
    xinput map-to-output $(xinput | grep "M Pen stylus" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}') $MONITOR
}

# Rotate Wacom input (xsetwacom needed)
function xwacom-rotate () {
    local XWACOMID=$(xinput | grep "M Pen stylus" | awk -v k=id '{for(i=2;i<=NF;i++) {split($i,a,"="); m[a[1]]=a[2]} print m[k]}')
    if (( $# == 0 )); then
        xsetwacom --set $XWACOMID Rotate half
        return
    fi
    case $1 in
        "0")
            xsetwacom --set $XWACOMID Rotate none
            ;;
        "1")
            xsetwacom --set $XWACOMID Rotate ccw
            ;;
        "2")
            xsetwacom --set $XWACOMID Rotate half
            ;;
        "3")
            xsetwacom --set $XWACOMID Rotate cw
            ;;
        *)
            echo "enter a position from 0 to 3"
            ;;
    esac
}

# Cycle through keyboard layout
function keyboard-next () {
    case $(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}') in
        "gb")
            setxkbmap -layout it
            echo "it layout"
            ;;
        "it")
            setxkbmap -layout us
            echo "us layout"
            ;;
        *)
            setxkbmap -layout gb
            echo "gb layout"
            ;;
    esac
    xmodmap ~/.Xmodmap
}

# Edit office files from within vim (pandoc needed)
function ded () {
    doc=$(basename -- "$1")
    new="${doc%.*}".md
    pandoc $doc -o $new
    vim $new
}

# Open vim session
function vs () {
    if [[ -f "$HOME/.vim/sessions/last" ]]; then
        /bin/vim -S $HOME/.vim/sessions/last
    else
        /bin/vim
    fi
}

# tig wrapper
function _tig () {
    if [ -d ".git" ]; then
        if [ $(git rev-list --all --count) -eq 0 ]; then
            tig status
        else
            tig
        fi
    else
        printf "%s\n%s " "Not in a git repo" "Press enter to continue"; read ans
    fi
}

# Change directory exiting from fff
function _fff () {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

# Change directory exiting from shfm
function _shfm () {
    ~/bin/shfm/shfm "$@"
    cd "$(cat ~/.shfm.tmp)"  # cd "$(command shfm "$@")"
    rm -f ~/.shfm.tmp
}

# Change directory exiting from rover
function _rover () {
    if command -v rover >/dev/null 2>&1; then
        rover "$@" -d ~/.rover$$.tmp
        cd "$(cat ~/.rover$$.tmp)"
        rm -f ~/.rover$$.tmp
    else
        echo "rover is not installed"
    fi
}

# Browse through images in directory after opening a single file
function _sxiv () {
    if command -v sxiv >/dev/null 2>&1; then
        if [ -d "${@: -1}" ] || [ -h "${@: -1}" ]; then
            sxiv -t "$@"
        else
            sxiv    "$@"
        fi
    elif command -v feh >/dev/null 2>&1; then
        feh "$@"
    else
        echo "Please install SXIV or FEH!"
    fi
}




### Set alias
#############

alias c="clear"
alias ..="cd .."
alias mkdir="mkdir -pv"
alias free="free -mt"
alias ps="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias wget="wget -c"
alias histg="history | grep"
alias myip="curl ipv4.icanhazip.com"
alias grep="grep --color=auto"
alias reload="source ~/.bashrc"

# use exa instead of ls (if present)
alias ls="ls -CF --color=auto" && [[ -f /bin/exa ]] && alias ls="exa -GF --git --icons --color=auto"
alias ll="ls -CFl --color=auto" && [[ -f /bin/exa ]] && alias ll="exa -GFl --git --icons --color=auto"
alias la="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias la="exa -la --git --icons --group-directories-first"
alias lt="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias lt="exa -la --git --icons --group-directories-first --tree"
alias lss="ls -lhF | less" && [[ -f /bin/exa ]] && alias lss="exa -la --git --icons --group-directories-first | less"

# use lfs instead of df
alias df="df -ahiT --total" && [[ -f /bin/lfs ]] && alias df="lfs"

# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias rmf="rm -rfi"

# xclip copy-pasta
alias copy="xclip -i -selection clipboard"
alias pasta="xclip -o -selection clipboard"
alias xcopy="xclip-copyfile"
alias xpasta="xclip-pastefile"
alias xcut="xclip-cutfile"

# pacman and paru aliases
alias pacche="sudo paccache -r"
alias packey="sudo pacman -S archlinux-keyring"
alias pacsyy='sudo pacman -Syy'
alias pacsyu='sudo pacman -Syyu'
alias parche='paru -Scc'
alias parsyu='paru -Syu --noconfirm'
alias parsua='paru -Sua --noconfirm'

# aliases for fff, shfm, rover, tig, sxiv and vim
alias fff="_fff"
alias shfm="_shfm"
alias rover="_rover"
alias tig="_tig"
alias sxiv="_sxiv" && [[ -f ~/.config/sxiv/supersxiv ]] && alias sxiv="~/.config/sxiv/supersxiv"
alias vi="/bin/vim --noplugin -n -i NONE"

# aliases for cat, less, top
alias cat="cat" && [[ -f /bin/bat ]] && alias cat="bat"
alias less="less" && [[ -f /bin/vimpager ]] && alias less="vimpager +"
alias top="top" && [[ -f btm ]] && alias top="btm -bT"

# logout aliases
alias reboot="systemctl reboot"
alias poweroff="systemctl -i poweroff"

# stow aliases
alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"

# xresources and keyboard aliases
alias xload="xrdb ~/.Xresources"
alias keyboard-swap="xmodmap ~/.Xmodmap"

# background and lockscreen aliases
alias background="feh --bg-fill "
alias lockscreen="echo -e 'Install slock: https://github.com/matteogiorgi/slock'" && [[ -x "$(command -v slock)" ]] && alias lockscreen="slock"

# other aliases
alias xpipes="pipes -n 5 -i 0.025"
alias noteblock="[[ -f $HOME/.noteblock ]] && $EDITOR $HOME/.noteblock || echo 'No notes available.'"

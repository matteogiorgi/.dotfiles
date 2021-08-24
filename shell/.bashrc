######################################################
#                      DOOM BASH                     #
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


### Set prompt
##############

PS1="${Yellow}\u@\h${NC}: ${Blue}\w${NC} \\$ "


### set common functions
########################

# Set custom keys:
function keyswap () { xmodmap ~/.Xmodmap ; }

# Reload xresources:
function xload () { xrdb ~/.Xresources ; }

# Reload shell config file:
function reload () { source ~/.bashrc ; }

# Show keychords and keymaps:
function keyinfo () { nvimpager -p ~/.keys.txt ; }

# Cycle through keyboard layout:
function laynext () {
    case $(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}') in
        "gb")
            setxkbmap -layout it
            ;;
        "it")
            setxkbmap -layout us
            ;;
        *)
            setxkbmap -layout gb
            ;;
    esac
    xrdb ~/.Xresources
}

# Change wallpaper randomly:
function bgrandom () {
    cd $HOME/Pictures/wallpapers/wallogo
    feh --bg-fill $( echo $( /usr/bin/ls -l | awk '{if (NR!=1) print $9}' | sort -R | tail -1 ))
    cd - 1>/dev/null
}

# Set background:
function background () { feh --bg-fill $1 ; }

# Set lockscreen:
function lockscreen () { betterlockscreen -u $1 ; }

# Start video-wallpaper:
function wallvideo () { wallset --video $1 ; }

# Stop video-wallpaper:
function wallquit () { wallset --quit ; }

# Change directory exiting from vifm
function _vfm () {
    local dst="$(command ~/.config/vifm/scripts/vifmrun "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

# Change directory exiting from ranger
function _rfm () {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# Change directory exiting from shfm
function _sfm () {
    ~/bin/shfm/shfm "$@"
    cd "$(cat ~/tmp.XXXXXX)"  # cd "$(command shfm "$@")"
    rm -f ~/tmp.XXXXXX
}

# Change directory exiting from fff
function _ffm () {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/fff.d")"
}


### Set alias
#############

alias c='clear'
alias ..='cd ..'
alias mkdir='mkdir -pv'
alias free='free -mt'
alias ps='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias wget='wget -c'
alias histg='history | grep'
alias myip='curl ipv4.icanhazip.com'
alias grep='grep --color=auto'

# use exa instead of ls (if present)
alias ls="ls -CF --color=auto" && [[ -f /bin/exa ]] && alias ls="exa -GF --git --color=auto"
alias ll="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias ll="exa -la --git --icons --group-directories-first"
alias lt="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias lt="exa -la --git --icons --group-directories-first --tree"

# aliases for vifm, ranger, shfm and fff
alias vifm="_vfm"
alias ranger="_rfm"
alias shfm="_sfm"
alias fff="_ffm"


### Source some shit
#####################

# pfetch
[[ -f $HOME/bin/ufetch ]] && $HOME/bin/ufetch

# broot
[[ -f $HOME/.config/broot/launcher/bash/br ]] && source $HOME/.config/broot/launcher/bash/br

# fzf
[[ -f $HOME/.fzf.bash ]] && source $HOME/.fzf.bash
[[ -f $HOME/.config/fzf/completion.bash ]] && source $HOME/.config/fzf/completion.bash
[[ -f $HOME/.config/fzf/key-bindings.bash ]] && source $HOME/.config/fzf/key-bindings.bash

# fff
[[ -f $HOME/bin/fff/.fffrc ]] && source $HOME/bin/fff/.fffrc


### Environment variables
#########################

export PAGER="nvimpager"      # nvimpager,nvim +Man!
export MANPAGER="nvimpager"   # nvimpager,nvim +Man!
export VISUAL="nvim"          # nvim,vim,amp,micro,vscodium
export EDITOR="nvim"          # nvim,vim,amp,micro,vscodium
export BROWSER="qutebrowser"  # qutebrowser,luakit,vimb
export READER="zathura"
export GOPATH="$HOME/go"      # go directory should stay in $HOME

# better not export $TERM: problems with broot image preview
export TERM="xterm-256color"  # screen-256color,xterm-256color,xterm-kitty
export MYTERM="lxterminal"    # kitty,alacritty,lxterminal,xterm

# need the following to avoid ranger loading configs twice
export RANGER_LOAD_DEFAULT_RC="FALSE"

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively (simpler one: PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}")
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$HOME/.emacs.d/bin"

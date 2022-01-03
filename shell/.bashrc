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


### Environment variables (remember to install vim, amp, most, brave, zathura)
##############################################################################

export PAGER="most" && [[ -f /bin/vimpager ]] && export PAGER="vimpager"
export MANPAGER="most" && [[ -f /bin/vimpager ]] && export MANPAGER="vimpager"
export VISUAL="amp" && [[ -f /bin/vim ]] && export VISUAL="vim"
export EDITOR="amp" && [[ -f /bin/vim ]] && export EDITOR="vim"
export BROWSER="brave"
export READER="zathura"
export GOPATH="$HOME/go"

# better not export $TERM: problems with broot image preview
export TERM="xterm-256color"  # xterm-256color,screen-256color

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively (simpler one: PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}")
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$HOME/.emacs.d/bin"

# better do not export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
export FZF_ALT_C_COMMAND='/bin/ls -ap . | grep -E "/$" | tr -d "/"'


### Set prompt
##############

PS1="${Yellow}\u@\h${NC}: ${Blue}\w${NC} \\$ "


### set common functions
########################

# Yank file inside x11 clipboard (xclip needed)
function yy () { cat $1 | xclip ; }

# Paste file from x11 clipboard (xclip needed)
function pp () { xclip -o > $1 ; }

# Set input to a single monitor
function xio () { xinput map-to-output $1 $2 ; }

# Rotate Wacom input (xsetwacom needed)
function xrotate () { xsetwacom --set $1 Rotate half ; }

# Cycle through keyboard layout:
function laynext () {
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

# Change wallpaper randomly:
function bgrandom () {
    cd $HOME/Pictures/wallpapers/wallogo
    feh --bg-fill $( echo $( /usr/bin/ls -l | awk '{if (NR!=1) print $9}' | sort -R | tail -1 ))
    cd - 1>/dev/null
}

# Edit office files from within vim:
function docxedit () {
    doc=$(basename -- "$1")
    new="${doc%.*}".md
    pandoc $doc -o $new
    vim $new
}

# Change directory exiting from shfm
function _shfm () {
    ~/bin/shfm/shfm "$@"
    cd "$(cat ~/tmp.XXXXXX)"  # cd "$(command shfm "$@")"
    rm -f ~/tmp.XXXXXX
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
alias ll="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias ll="exa -la --git --icons --group-directories-first"
alias lt="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias lt="exa -la --git --icons --group-directories-first --tree"

# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# pacman and paru aliases
alias pacsyu='sudo pacman -Syyu'
alias parsyu='paru -Syu --noconfirm'
alias parsua='paru -Sua --noconfirm'

# aliases for shfm and sxiv
alias shfm="_shfm"
alias sxiv="_sxiv" && [[ -f ~/.config/sxiv/supersxiv ]] && alias sxiv="~/.config/sxiv/supersxiv"

# logout aliases
alias reboot="systemctl reboot"
alias poweroff="systemctl -i poweroff"

# stow aliases
alias stow="stow -S"
alias restow="stow -R"
alias unstow="stow -D"

# xresources and keyboard aliases
alias xload="xrdb ~/.Xresources"
alias keyswap="xmodmap ~/.Xmodmap"
alias touchreset="systemctl --user restart touchcursor.service"

# background and lockscreen aliases
alias background="feh --bg-fill "
alias lockscreen="slock"

# other useful aliases
alias jj="shfm"
alias vv="vim ."


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

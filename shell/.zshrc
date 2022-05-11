######################################################
#                      ZSH CONF                      #
######################################################




### Set/unset ZSH options
#########################

# setopt NOHUP
# setopt NOTIFY
# setopt NO_FLOW_CONTROL
# setopt AUTO_LIST
# setopt AUTO_REMOVE_SLASH
# setopt AUTO_RESUME
# setopt HASH_CMDS
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
setopt CORRECT
setopt EXTENDED_HISTORY
setopt MENUCOMPLETE
setopt ALL_EXPORT
unsetopt BG_NICE




### Set/unset shell options
############################

setopt notify globdots correct pushdtohome cdablevars autolist
setopt correctall autocd recexact longlistjobs
setopt autoresume histignoredups pushdsilent
setopt autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash




### Autoload zsh modules when they are referenced
#################################################

# zmodload -ap zsh/mapfile mapfile
autoload -U history-search-end
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end




### Set variables
#################

# PATH is exported together with other variables (below ther's an alternative)
# PATH="/usr/local/bin:/usr/local/sbin/:$PATH"

HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';




### Load colors
###############

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done




### Set Colors to use in in the script
######################################

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset




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

[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f $HOME/Pictures/wallpapers/src ]] && source $HOME/Pictures/wallpapers/src




### Source extra shit
#####################

# fm6000, pfetch or ufetch
[[ -f $HOME/bin/fm6000 ]] && $HOME/bin/fm6000

# fzf
[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
[[ -f $HOME/.config/fzf/completion.zsh ]] && source $HOME/.config/fzf/completion.zsh
[[ -f $HOME/.config/fzf/key-bindings.zsh ]] && source $HOME/.config/fzf/key-bindings.zsh




### Set prompt
##############

PR_NO_COLOR="%{$terminfo[sgr0]%}"
PS1="[%(!.${PR_RED}%n.$PR_LIGHT_YELLOW%n)%(!.${PR_LIGHT_YELLOW}@.$PR_RED@)$PR_NO_COLOR%(!.${PR_LIGHT_RED}%U%m%u.${PR_LIGHT_GREEN}%U%m%u)$PR_NO_COLOR:%(!.${PR_RED}%2c.${PR_BLUE}%2c)$PR_NO_COLOR]%(?..[${PR_LIGHT_RED}%?$PR_NO_COLOR])%(!.${PR_LIGHT_RED}#.${PR_LIGHT_GREEN}$) "
RPS1="$PR_LIGHT_YELLOW(%D{%a %d %b, %H:%M}) $PR_LIGHT_CYAN$(battery)%%$PR_NO_COLOR"
unsetopt ALL_EXPORT




### Set common functions
########################

# Get IP adress
function my_ip () { curl ifconfig.co ; }

# Find a file with a pattern in name
function ff () { find . -type f -iname '*'"$*"'*' -ls ; }

# Get current host related info
function sysinfo () {
    echo -e "\n${BRed}System Informations:$NC " ; uname -a
    echo -e "\n${BRed}Online User:$NC " ; w -hs | cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Date :$NC " ; date
    echo -e "\n${BRed}Server stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Public IP Address :$NC " ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo -e "\n${BRed}CPU info :$NC "; cat /proc/cpuinfo ;
    echo -e "\n"
}

# Creates an archive (*.tar.gz) from given directory (better to use atool anyway)
function maketar () { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/" ; }

# Create a ZIP archive of a file or folder (better to use atool anyway)
function makezip () { zip -r "${1%%/}.zip" "$1" ; }

# ps motherfuckers
function steroidps () { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

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

# Jump directorys upwards until it hits a directory with multiple folders
function up () {
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
        do
          d=$d/..
        done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Make and jump in mate
function mcd () {
    mkdir -p $1
    cd $1
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

alias cls="clear"
alias ..="cd .."
alias cd..="cd .."
alias home="cd ~"
alias mkdir="mkdir -pv"
alias mkfile="touch"
alias rm="rm -rfi"
alias userlist="cut -d: -f1 /etc/passwd"
alias free="free -mt"
alias du="du -ach | sort -h"
alias ps="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias wget="wget -c"
alias histg="history | grep"
alias myip="curl http://ipecho.net/plain; echo"
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias folders="find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn"
alias grep="grep --color=auto"
alias reload="source ~/.zshrc"

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
alias top="top" && [[ -x "$(command -v btm)" ]] && alias top="btm -bT"

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




### Bind keys
#############

autoload -U compinit
compinit

# vi mode
bindkey -v

# unbind default fzf keybindings
bindkey -r '\ec'
bindkey -r '^R'
bindkey -r '^T'

# zsh keybindings
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space     # also do history expansion on space
bindkey '^I' complete-word  # complete on tab, leave expansion to _expand
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# dope keybindings
bindkey    '\eh' fzf-history-widget  # [H] fuzzy-history
bindkey    '\ej' fzf-cd-widget       # [J] fuzzy-jump
bindkey    '\ek' fzf-file-widget     # [K] fuzzy-finder
bindkey -s '\el' 'launch^M'          # [L] launcher
bindkey -s '\ey' 'noteblock^M'       # [Y] noteblock
bindkey -s '\eu' 'tig^M'             # [U] git-client
bindkey -s '\ei' 'fff^M'             # [I] fucking-fast-fm
bindkey -s '\eo' 'vs^M'              # [O] vimsession




### Completion Styles
#####################

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# ???
# zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
# zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'




### NEW completion
##################

# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain, then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}')

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'

# the same for old style completion
# fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort

# SSH Completion
zstyle ':completion:*:scp:*' tag-order files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show




### Alias reveal
################

local cmd_alias=""

alias_for() {
    [[ $1 =~ '[[:punct:]]' ]] && return
    local search=${1}
    local found="$( alias $search )"
    if [[ -n $found ]]; then
        found=${found//\\//}          # Replace backslash with slash
        found=${found%\'}             # Remove end single quote
        found=${found#"$search='"}    # Remove alias name
        echo "${found} ${2}" | xargs  # Return found value (with parameters)
    else
        echo ""
    fi
}

expand_command_line() {
    first=$(echo "$1" | awk '{print $1;}')
    rest=$(echo ${${1}/"${first}"/})

    if [[ -n "${first//-//}" ]]; then                    # is not hypen
        cmd_alias="$(alias_for "${first}" "${rest:1}")"  # Check if there's an alias for the command
        if [[ -n $cmd_alias ]]; then                     # If there was
            echo "${Green}❯ ${Yellow}${cmd_alias}${NC}"  # Print it
        fi
    fi
}

pre_validation() {
    [[ $# -eq 0 ]] && return  # If there's no input, return. Else...
    expand_command_line "$@"
}


autoload -U add-zsh-hook             # Load the zsh hook module. 
add-zsh-hook preexec pre_validation  # Adds the hook (-d to revove it)

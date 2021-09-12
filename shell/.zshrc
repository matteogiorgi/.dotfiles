######################################################
#                      DOOM ZSH                      #
######################################################


### Set/unset ZSH options
#########################

# setopt NOHUP
# setopt NOTIFY
# setopt NO_FLOW_CONTROL
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
# setopt AUTO_LIST
# setopt AUTO_REMOVE_SLASH
# setopt AUTO_RESUME
unsetopt BG_NICE
setopt CORRECT
setopt EXTENDED_HISTORY
# setopt HASH_CMDS
setopt MENUCOMPLETE
setopt ALL_EXPORT


### Set/unset shell options
############################

setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash


### Autoload zsh modules when they are referenced
#################################################

autoload -U history-search-end
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
# zmodload -ap zsh/mapfile mapfile
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


### Set prompt
##############

PR_NO_COLOR="%{$terminfo[sgr0]%}"
PS1="[%(!.${PR_RED}%n.$PR_LIGHT_YELLOW%n)%(!.${PR_LIGHT_YELLOW}@.$PR_RED@)$PR_NO_COLOR%(!.${PR_LIGHT_RED}%U%m%u.${PR_LIGHT_GREEN}%U%m%u)$PR_NO_COLOR:%(!.${PR_RED}%2c.${PR_BLUE}%2c)$PR_NO_COLOR]%(?..[${PR_LIGHT_RED}%?$PR_NO_COLOR])%(!.${PR_LIGHT_RED}#.${PR_LIGHT_GREEN}$) "
RPS1="$PR_LIGHT_YELLOW(%D{%m-%d %H:%M})$PR_NO_COLOR"
unsetopt ALL_EXPORT


### set common functions
########################

# Get IP adress:
function my_ip () {
   curl ifconfig.co
}

# Find a file with a pattern in name:
function ff () {
    find . -type f -iname '*'"$*"'*' -ls ;
}

# Get current host related info:
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

# Compressed file extractor:
function extract () {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

# Creates an archive (*.tar.gz) from given directory:
function maketar () { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder:
function makezip () { zip -r "${1%%/}.zip" "$1" ; }

# ps motherfuckers:
function my_ps () { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

# Set custom keys:
function keyswap () { xmodmap ~/.Xmodmap ; }

# Reload xresources:
function xload () { xrdb ~/.Xresources ; }

# Reload shell config file:
function reload () { source ~/.zshrc ; }

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

# Jump directorys upwards until it hits a directory with multiple folders:
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

# Make and jump in mate:
function mcd () {
    mkdir -p $1
    cd $1
}

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
    local tempfile="$(mktemp -t tmp.XXXXXX)"
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
    cd "$(cat "$FFF_CD_FILE")"  # ${XDG_CACHE_HOME:=${HOME}/.cache}/fff/fff.d"
}


### Set alias
#############

alias cls="clear"
alias ..="cd .."
alias cd..="cd .."
alias home="cd ~"
alias df="df -ahiT --total"
alias mkdir="mkdir -pv"
alias mkfile="touch"
alias rm="rm -rfi"
alias userlist="cut -d: -f1 /etc/passwd"
alias lsl="ls -lhFA | less"
alias free="free -mt"
alias du="du -ach | sort -h"
alias ps="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias wget="wget -c"
alias histg="history | grep"
alias myip="curl http://ipecho.net/plain; echo"
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias grep='grep --color=auto'

# use exa instead of ls (if present)
alias ls="ls -CF --color=auto" && [[ -f /bin/exa ]] && alias ls="exa -GF --git --icons --color=auto"
alias ll="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias ll="exa -la --git --icons --group-directories-first"
alias lt="ls -lisa --color=auto" && [[ -f /bin/exa ]] && alias lt="exa -la --git --icons --group-directories-first --tree"

# aliases for vifm, ranger, shfm and fff
alias vifm="_vfm"
alias ranger="_rfm"
alias shfm="_sfm"
alias fff="_ffm"


### Bind keys
#############

autoload -U compinit
compinit
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST


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


### Source plugins
##################

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


### Source extra shit
#####################

# pfetch
[[ -f $HOME/bin/pfetch ]] && $HOME/bin/pfetch

# broot
[[ -f $HOME/.config/broot/launcher/bash/br ]] && source $HOME/.config/broot/launcher/bash/br

# fzf
[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
[[ -f $HOME/.config/fzf/completion.zsh ]] && source $HOME/.config/fzf/completion.zsh
[[ -f $HOME/.config/fzf/key-bindings.zsh ]] && source $HOME/.config/fzf/key-bindings.zsh

# fff
[[ -f $HOME/bin/fff/.fffrc ]] && source $HOME/bin/fff/.fffrc


### Environment variables
#########################

export PAGER="most" && [[ -f /bin/nvimpager ]] && export PAGER="nvimpager"        # nvimpager,nvim +Man!
export MANPAGER="most" && [[ -f /bin/nvimpager ]] && export MANPAGER="nvimpager"  # nvimpager,nvim +Man!
export VISUAL="vim" && [[ -f /bin/nvim ]] && export VISUAL="nvimpager"            # nvim,vim,amp,micro,vscodium
export EDITOR="vim" && [[ -f /bin/nvim ]] && export EDITOR="nvimpager"            # nvim,vim,amp,micro,vscodium
export BROWSER="qutebrowser"                                                      # qutebrowser,luakit,vimb
export READER="zathura"
export GOPATH="$HOME/go"                                                          # go directory should stay in $HOME

# better not export $TERM: problems with broot image preview
export TERM="xterm-256color"  # screen-256color,xterm-256color,xterm-kitty
export MYTERM="lxterminal"    # kitty,alacritty,lxterminal,xterm

# need the following to avoid ranger loading configs twice
export RANGER_LOAD_DEFAULT_RC="FALSE"

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively (simpler one: PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}")
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$HOME/.emacs.d/bin"

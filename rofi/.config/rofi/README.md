## Rofi custom louncher

Add the folling function to your `~/bin` (or any folder in your `$PATH`):

```
#!/usr/bin/env bash

NAME=$(basename "$0")
VER="0.5"

usage()
{
    cat <<- EOF

 USAGE:  $NAME [OPTIONS]
 OPTIONS:
     -h,--help                  Display this message
     -v,--version               Display script version
     -r,--run                   Display launcher/prompt
     -w,--window                Switch between windows
     -l,--logout                System logout dialog
 Without any options the run dialog will be opened.

EOF
}

for arg in "$@"; do
    case $arg in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            echo -e "$NAME -- Version $VER"
            exit 0
            ;;
        -r|--run)
            rofi -modi drun,run -show drun -i -sidebar-mode
            ;;
        -w|--window)
            rofi -modi window -show window -i
            ;;
        -l|--logout)
            if grep -q 'exec startx' $HOME/.*profile; then
                ANS="$(rofi -sep "|" -dmenu -i -p 'system' \
                    -lines 3 <<< "Lock|Reboot|Shutdown")"
            else
                ANS="$(rofi -sep "|" -dmenu -i -p 'system' \
                    -lines 4 <<< "Lock|Logout|Reboot|Shutdown")"
            fi
            case "$ANS" in
                *Lock) betterlockscreen -l dim ;;
                *Reboot) systemctl reboot ;;
                *Shutdown) systemctl -i poweroff ;;
                *Logout) loginctl terminate-session $XDG_SESSION_ID ;;
            esac
            ;;
        *)
            printf "\nOption does not exist: %s\n\n" "$arg"
            exit 2
    esac
done

(( $# == 0 )) && "$0" -r

exit 0
```

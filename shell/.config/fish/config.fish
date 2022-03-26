if status is-interactive
    set fish_greeting

    set PAGER "vimpager"
    set MANPAGER "vimpager"
    set VISUAL "vim"
    set EDITOR "vim"
    set BROWSER "brave"
    set READER "zathura"
    set GOPATH "$HOME/go"
    set OPEN 'swallow'

    set -e fish_user_paths
    set -U fish_user_paths "$PATH  find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p"  $HOME/.local/bin  $HOME/.cargo/bin  $GOPATH/bin  $HOME/.emacs.d/bin"  $fish_user_paths

    set fish_color_normal brcyan
    set fish_color_autosuggestion '#7d7d7d'
    set fish_color_command brcyan
    set fish_color_error '#ff6c6b'
    set fish_color_param brcyan

    function fish_user_key_bindings
        fish_vi_key_bindings
    end
end

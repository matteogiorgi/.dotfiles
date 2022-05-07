# special Haskell exports (curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh)
export GHCUP_BIN="$HOME/.ghcup/bin"
export CABAL_BIN="$HOME/.cabal/bin"

# other special exports
export EMACS_BIN="$HOME/.emacs.d/bin"
export CARGO_BIN="$HOME/.cargo/bin"
export GOPATH_BIN="$HOME/go/bin"

# set PATH to includes user's bin, go's bin, cargo's bin and emacs's bin recursively (simpler one: PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}")
export PATH="$PATH:$( find $HOME/bin/ -maxdepth 2 -type d -not -path "/.git/*" -printf ":%p" ):$HOME/.local/bin:$EMACS_BIN:$GHCUP_BIN:$CABAL_BIN:$CARGO_BIN:$GOPATH_BIN"

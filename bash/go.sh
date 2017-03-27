# set up go version manager
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

if [ -d "$HOME/gocode" ]; then
  export GOPATH=$HOME/gocode
  if [ -d "$GOPATH/bin" ]; then
    export PATH=$PATH:$GOPATH/bin
  fi
fi

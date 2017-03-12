# pyenv root
export PYENV_ROOT="$HOME/.pyenv"

# Add pyenv root to PATH
# and initialize pyenv
if [[ -d $PYENV_ROOT ]];then
    PATH="$PYENV_ROOT/bin:$PATH"
    # initialize pyenv
    eval "$(pyenv init -)"
    # initialize pyenv virtualenv
    eval "$(pyenv virtualenv-init -)"
fi

source ~/.pyenv/completions/pyenv.bash

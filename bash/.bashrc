#!/usr/bin/env bash

## better bash defaults from sensible bash https://github.com/mrzool/bash-sensible

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber
# Update window size after every command
shopt -s checkwinsize
# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space
# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

## SMARTER TAB-COMPLETION (Readline bindings) ##
# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

## SANE HISTORY DEFAULTS ##
# Append to the history file, don't overwrite it
shopt -s histappend
# Save multi-line commands as one command
shopt -s cmdhist
# Record each line as it gets issued
PROMPT_COMMAND='history -a'
# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000
# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '
# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

## BETTER DIRECTORY NAVIGATION ##
# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null
# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH=".:~/work"
# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars
# Examples:
export dotfiles="$HOME/dotfiles"
export dev="$HOME/dev"

# Load aliases
if [ -f ~/.aliases.sh ]; then
  source ~/.aliases.sh
fi

# set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT ]];then
    PATH="$PYENV_ROOT/bin:$PATH"
    # initialize pyenv
    eval "$(pyenv init -)"
    # initialize pyenv virtualenv
    eval "$(pyenv virtualenv-init -)"
fi

# set up node version manager stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# set up go version manager
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

if [ -d "$HOME/gocode" ]; then
  export GOPATH=$HOME/gocode
  if [ -d "$GOPATH/bin" ]; then
    export PATH=$PATH:$GOPATH/bin
  fi
fi

# complete :allthethings:
# shellcheck disable=SC1090
source "$dotfiles/bash-complete/git-completion.bash"
source "$dotfiles/bash-complete/docker-compose-completion.bash"
[ -x "$(command -v kubectl)" ]; source <(kubectl completion bash)
source ~/.pyenv/completions/pyenv.bash

export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

TERM='rxvt-unicode'
COLORTERM='rxvt-unicode-256color'

# add homedir bin
export PATH=$HOME/bin:$PATH
# add pipsi installed scripts to $PATH
export PATH="$PATH:$HOME/.local/bin"
# add composer vendor bin to path
export PATH=~/.config/composer/vendor/bin:$PATH
# powerline prompt
#powerline-daemon -q
#POWERLINE_BASH_CONTINUATION=1
#POWERLINE_BASH_SELECT=1
#source "$HOME/.local/venvs/powerline-status/lib/python3.5/site-packages/powerline/bindings/bash/powerline.sh"

[[ $- = *i* ]] && source "$dotfiles/submodules/liquidprompt/liquidprompt"

[ -f "$HOME/aws/alises.sh" ]; source "$HOME/aws/aliases.sh"

awscreds() {
    if [ -z "$*" ]
    then
        ls -1 "$HOME/aws/creds"
    else
        if [ -f "$HOME/aws/creds/$1" ] && [[ $1 != "unset" ]]
        then
            prompt_tag "\033[38;5;208m${1}\033[0m"
            source "$HOME/aws/creds/$1"
        else
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
            prompt_tag
        fi
    fi
}
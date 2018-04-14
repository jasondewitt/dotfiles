#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

prompt_tag()
{
    PS1_PREFIX="$(_ins_sr "$1")"
}

# insert a space on the right
_ins_sr()
{
    [[ -n "$1" ]] && echo -nE "$1 "
}

# insert a space on the left
_ins_sl()
{
    [[ -n "$1" ]] && echo -nE " $1"
}

# insert two space, before and after
_ins_sb()
{
    [[ -n "$1" ]] && echo -nE " $1 "
}

source "$HOME/.colors.sh"

find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    #git_branch="($branch)"
    git_branch="${txtgitbranch} ${branch}${txtrst}"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='${txtgitdirty}*${txtrst}'
  else
    git_dirty=''
  fi
}

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

# add homedir bin
export PATH=$HOME/bin:$PATH
# add pipsi installed scripts to $PATH
export PATH="$PATH:$HOME/.local/bin"
# add composer vendor bin to path
export PATH=~/.config/composer/vendor/bin:$PATH


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

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
pyenvVirtualenvUpdatePrompt() {
    RED='\[\e[0;31m\]'
    GREEN='\[\e[0;32m\]'
    BLUE='\[\e[0;34m\]'
    RESET='\[\e[0m\]'
    #[ -z "$PYENV_VIRTUALENV_ORIGINAL_PS1" ] && export PYENV_VIRTUALENV_ORIGINAL_PS1="$PS1"
    [ -z "$PYENV_VIRTUALENV_GLOBAL_NAME" ] && export PYENV_VIRTUALENV_GLOBAL_NAME="$(pyenv global)"
    VENV_NAME="$(pyenv version-name)"
    VENV_NAME="${VENV_NAME##*/}"
    GLOBAL_NAME="$PYENV_VIRTUALENV_GLOBAL_NAME"

    # non-global versions:
    COLOR="$BLUE"
    # global version:
    [ "$VENV_NAME" == "$GLOBAL_NAME" ] && COLOR="$RED"
    # virtual envs:
    [ "${VIRTUAL_ENV##*/}" == "$VENV_NAME" ] && COLOR="$GREEN"


    export PYENV_PROMPT="($COLOR${VENV_NAME}$RESET) "
    #export PYENV_PROMPT="hello"
 #   if [ -z "$COLOR" ]; then
 #       PS1="$PYENV_VIRTUALENV_ORIGINAL_PS1"
 #   else
 #       PS1="($COLOR${VENV_NAME}$RESET)$PYENV_VIRTUALENV_ORIGINAL_PS1"
 #   fi
 #   export PS1
}
PROMPT_COMMAND="pyenvVirtualenvUpdatePrompt; $PROMPT_COMMAND"


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
if [ -f /etc/bash_completion ];
then
    source /etc/bash_completion
fi
source "$dotfiles/bash-complete/git-completion.bash"
source "$dotfiles/bash-complete/docker-compose-completion.bash"
[ -x "$(command -v kubectl)" ]; source <(kubectl completion bash)
source ~/.pyenv/completions/pyenv.bash

TERM='rxvt-unicode-256color'
COLORTERM='rxvt-unicode-256color'


#export GITAWAREPROMPT="/home/jason/dotfiles/submodules/git-aware-prompt"
#source "${GITAWAREPROMPT}/main.sh"
# no liquid prompt sooooo slow on git repos
#[[ $- = *i* ]] && source "$dotfiles/submodules/liquidprompt/liquidprompt"
#[[ $- = *i* ]] && source "$dotfiles/submodules/polyglot/polyglot.sh"

# aws utilities
[ -f "$HOME/aws/alises.sh" ]; source "$HOME/aws/aliases.sh"
awscreds() {
    if [ -z "$*" ]
    then
        ls -1 "$HOME/aws/creds"
    else
        if [ -f "$HOME/aws/creds/$1" ] && [[ $1 != "unset" ]]
        then
            prompt_tag "${txtaws}${1}${txtrst}"
            source "$HOME/aws/creds/$1"
        else
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
            prompt_tag
        fi
    fi
}

# git prompt
PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"

#PS1="\[\033[32m\]\t \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
#export PS1="${txtcyn}${git_branch}${txtred}${git_dirty}${txtrst} $ "

_set_prompt () {
    PS1="${PS1_PREFIX}${PYENV_PROMPT}\w ${git_branch}${git_dirty}> "
}
PROMPT_COMMAND="$PROMPT_COMMAND ; _set_prompt"
#!/usr/bih/env bash
alias refresh='source ~/.bash_profile'

alias c='clear'
alias e='exit'

alias -- -='cd -'

alias lsd="ls -lF --color | grep --color=never '^d'"

alias notebook="cd ~/notebooks && jupyter notebook"
alias dig="dig +noall +answer"

# show only the headers without doing a HEAD request
alias curlheader="curl -D - -so /dev/null"

# ssl certificate checking functions
function sslsiteinfo () {
  echo | openssl s_client -connect $1:443 -servername $1 2>/dev/null | openssl x509 -noout -dates -issuer -subject
}

function sslinfo () {
  openssl x509 -in $1 -noout -dates -issuer -subject
}

function sslinfofull () {
  openssl x509 -in $1 -noout -text
}

function sslsiteinfofull () {
  echo | openssl s_client -connect $1:443 -servername $1 2>/dev/null | openssl x509 -noout -text
}

function lh () {
  docker run -t -v $PWD:/home/lighthouse lighthouse-debian lighthouse $1 --output json --output html
}

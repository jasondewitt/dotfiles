#!/usr/bih/env bash
alias refresh='source ~/.bash_profile'

alias c='clear'
alias e='exit'

alias -- -='cd -'

alias lsd="ls -lF --color | grep --color=never '^d'"

alias notebook="cd ~/notebooks && jupyter notebook"
alias dig="dig +noall +answer"

alias stopwow="killall Battle.net.exe Agent.exe; fixwow"
alias wpversions="curl https://api.wordpress.org/core/stable-check/1.0/"

#alias 10updocker="node ~/work/dev/wp-local-docker-v2/index.js"

# show only the headers without doing a HEAD request
alias curlheader="curl -D - -so /dev/null"
alias curltime='curlheader -w "Transfer %{time_starttransfer}\nConnect %{time_connect}\nNS %{time_namelookup}\nPre Transfer %{time_pretransfer}\nConnect %{time_connect}\nTotal %{time_total}\n"'

alias memusage="ps aux  | awk '{print $6/1024 \" MB\t\t\" $1}'  | sort -n"

alias onilog="tail -f /home/jason/.config/unity3d/Klei/Oxygen\ Not\ Included/Player.log"

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
  if [[ -z $2 ]]
  then
    servername="$2"
  else
    servername="$1"
  fi
  echo | openssl s_client -connect $1:443 -servername $servername 2>/dev/null | openssl x509 -noout -text
}

function lh () {
  docker run -t -v $PWD:/home/lighthouse lighthouse-debian lighthouse $1 --output json --output html
}

function update_runner_container () {
    for n in {2..4}
    do
        ssh runner${n} docker pull ${1}
    done

}

function allec2 () {
    for region in $(aws ec2 describe-regions --query "Regions[*].[RegionName]" --output text)
    do
        echo $region
        aws ec2 describe-instances --region "$region" | jq ".Reservations[].Instances[] | {type: .InstanceType, state: .State.Name, tags: .Tags, zone: .Placement.AvailabilityZone}"
        echo
    done
}

function wpsalts () {
    curl https://api.wordpress.org/secret-key/1.1/salt/
}


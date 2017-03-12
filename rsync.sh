#!/usr/bin/env bash

# if my desktop is online and booted to linux run rysnc to sync files

nc -vz 192.168.1.150 22
if [ "$?" = 0 ]
then
  cd /Users/jason/work/work
  rsync -avz desktop:/home/jason/work/* .
fi

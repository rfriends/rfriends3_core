#!/bin/bash
# =========================================
# install rfriends for alpine
#
# =========================================
# 1.0 2025/04/15 new
#
ver=1.0
echo start $ver
echo
# -----------------------------------------
testing="@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing"
sudo grep $testing /etc/apk/repositories
if [ $? -eq 1 ]; then
  echo $testing | sudo tee -a /etc/apk/repositories
fi
# -----------------------------------------
export distro="alpine"
export cmd="apk add"
export cmdupdate="apk update"

export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""

# now lighttpd not supported
# use built in server (sh rfriends3/rf3server.sh) 
export optlighttpd="on2"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="samba"
export atd="atd"
export cron="crond"
export ipcm="ip a"
#
sudo apk update
apk --update-cache add tzdata
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

sh common.sh 2>&1 | tee common.log
# -----------------------------------------
sudo grep -x "$user" /etc/at.allow
if [ $? -eq 1 ]; then
  echo $user | sudo tee -a /etc/at.allow
fi
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

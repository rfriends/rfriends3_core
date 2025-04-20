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
#export bindir="/usr/bin"

export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="samba"
export atd="atd"
export cron="crond"
export ipcm="ip a"

export app-openssh="openssh-server"
export app-cron="cronie"
export app-ffmpeg="ffmpeg"
export app-chromium="chromium"
export app-atomicparsley="atomicparsley"
#
sudo apk update
sudo apk --update-cache add tzdata
sudo cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

sh common.sh 2>&1 | tee common.log
# -----------------------------------------
echo /etc/at.allow
sudo grep -x "$user" /etc/at.allow
if [ $? -eq 1 ]; then
  echo $user | sudo tee -a /etc/at.allow
fi
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

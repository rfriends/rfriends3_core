#!/bin/bash
# =========================================
# install rfriends for iSH Shell(iPhone/iPad)
#
# =========================================
# 1.0 2025/07/21 new
# 1.1 2025/07/23 
# 1.2 2025/07/24 add ishcrond ishbg, remove local
#
ver=1.2
echo start $ver
echo
#sudo apk update

if [ ! -d /ish ]; then
  echo
  echo install_ish.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
#testing="https://dl-cdn.alpinelinux.org/alpine/edge/testing"
#sudo grep $testing /etc/apk/repositories
#if [ $? -eq 1 ]; then
#  echo $testing | sudo tee -a /etc/apk/repositories
#fi
# -----------------------------------------

export distro="alpine"
export cmd="apk add"
export cmdupdate="apk update"

export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export phpdir="/usr/bin"

export permitroot="on"
export optlighttpd="off"
export optsamba="off"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="samba"
export atd="atd"
export cron="crond"
export ipcm="ip a"

export app_openssh="openssh-server"
export app_cron="cronie"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium"
export app_atomicparsley="atomicparsley"
export app_iproute="iproute2"
#
sudo apk --update-cache add tzdata
#sudo cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

sudo apk add openrc 
#sudo apk add local
#sudo cp -f ish.start /etc/local.d/ish.start
#sudo chmod 700 /etc/local.d/ish.start
#sudo rc-update add local

sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
echo /etc/at.allow
sudo grep -x "$user" /etc/at.allow
if [ $? -eq 1 ]; then
  echo $user | sudo tee -a /etc/at.allow
fi
#sudo rc-service atd start
sudo rc-update add atd

sudo cp -f ish/ishcrond /etc/init.d/ishcrond
sudo chmod 755 /etc/init.d/ishcrond
sudo rc-update add ishcrond

sudo cp -f ish/ishbg /etc/init.d/ishbg
sudo chmod 755 /etc/init.d/ishbg
sudo rc-update add ishbg
# -----------------------------------------
#sudo rc-status
# finish
echo
echo finished
# -----------------------------------------

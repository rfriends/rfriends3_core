#!/bin/bash
# =========================================
# install rfriends for alpine
#
# =========================================
# 1.0 2025/04/15 new
# 1.4 2025/08/18 at,cron
#
ver=1.4
echo start $ver
echo
sudo apk update
if [ $? != 0 ]; then
  echo
  echo install_alpine.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
testing="https://dl-cdn.alpinelinux.org/alpine/edge/testing"
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
#export phpdir="/usr/bin"

export permitroot="off"
export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"
export optat="on"
export optcron="off"

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
mkdir $homedir/.cache

sudo apk --update-cache add tzdata
#sudo cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
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

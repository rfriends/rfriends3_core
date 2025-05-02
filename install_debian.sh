#!/bin/bash
# =========================================
# install rfriends for debian
# =========================================
# 1.0 2025/04/28 new

ver=1.0
echo start $ver
echo
sudo apt-get update
if [ $? != 0 ]; then
  echo
  echo install_debian.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
export distro="debian"
export cmd="apt-get install -y"
export cmdupdate="apt-get update"

#export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export phpdir="/usr/bin"

export optlighttpd="on1a"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smbd"
export atd="atd"
export cron="cron"

export app_openssh="openssh-server"
export app_cron="cron"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium-browser"
export app_atomicparsley="atomicparsley"
#

sudo apt-get install chromium -y
sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

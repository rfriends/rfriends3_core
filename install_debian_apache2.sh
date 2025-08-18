#!/bin/bash
# =========================================
# Install rfriends and Apache2 on debian
# =========================================
# 1.0 2025/08/14 new
# 1.1 2025/08/18 conf_dir
ver=1.1
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

export optlighttpd="off"
export optapache2="on"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export apache2="apache2"
export conf_dir="/etc/apache2"
export smbd="smbd"
export atd="atd"
export cron="cron"

export app_openssh="openssh-server"
export app_cron="cron"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium-browser"
export app_atomicparsley="atomicparsley"
export app_iproute="iproute2"
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

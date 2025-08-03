#!/bin/bash
# =========================================
# install rfriends for iSH Shell(iPhone/iPad)
#
# =========================================
# 1.0 2025/07/21 new
# 1.1 2025/07/23 
# 1.2 2025/07/24 add ishcrond ishbg, remove local
# 1.3 dev
# 1.5 usr,tmp 
#
ver=1.4
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
#testing="@testing "
testing=""
edge="https://dl-cdn.alpinelinux.org/alpine/edge/testing"
sudo grep $edge /etc/apk/repositories
if [ $? -eq 1 ]; then
  echo $testing$edge | sudo tee -a /etc/apk/repositories
fi
# -----------------------------------------
# 安定板
#export SCRIPT=rfriends3_latest_script.zip
# 開発版
export SCRIPT=rfriends3_dev_script.zip

export extract="7z -y x "
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

#export app_openssh="openssh-server"
export app_openssh="openssh"
export app_cron="cron"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium"
export app_atomicparsley="atomicparsley"
export app_iproute="iproute2"
#
sudo apk --update-cache add tzdata
#sudo cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sudo apk add openrc 

sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
mkdir -p $homedir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/usr2/"
tmpdir = "/tmp/"
EOF
# -----------------------------------------
echo /etc/at.allow
sudo grep -x "$user" /etc/at.allow
if [ $? -eq 1 ]; then
  echo $user | sudo tee -a /etc/at.allow
fi
# -----------------------------------------
sudo cp -f ish/crond.start /etc/local.d/crond.start
sudo chmod 700 /etc/local.d/crond.start

sudo cp -f ish/location.start /etc/local.d/location.start
sudo chmod 700 /etc/local.d/location.start

if [ $optlighttpd = "off" ]; then
  sudo rm /etc/local.d/lighttpd.start
else
  sudo cp -f ish/lighttpd.start /etc/local.d/lighttpd.start
  sudo chmod 700 /etc/local.d/lighttpd.start
fi
# -----------------------------------------
sudo rc-status
# -----------------------------------------
echo
echo usrdir
cat $homedir/rfriends3/config/usrdir.ini
# -----------------------------------------
cd ~/
echo sh rfriends3/rfriends3.sh > cui
echo sh rfriends3/rfriends3_server.sh > gui
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

#!/bin/bash
# =========================================
# install rfriends for suse
# =========================================
# 1.0 2025/04/15 new
#
ver=1.0
echo start $ver
echo
sudo zypper update
if [ $? != 0 ]; then
  echo
  echo install_suse.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
echo まず、以下の設定（セキュリティOFF）で実行し、 
echo うまくいったらセキュリティ設定を行ってください。
echo SELINUX=Disabled
echo firewalld disable
#
# SELINUXをDisabledに設定
sudo sed -i "/^SELINUX=enforcing/c SELINUX=Disabled" /etc/selinux/config

sudo systemctl status firewalld　> /dev/null
if [ $? = 0 ]; then
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
fi
# -----------------------------------------
export distro="suse"
export cmd="zypper install -y"
export cmdupdate="zypper update"

#export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export phpdir="/usr/bin"

# now lighttpd not supported
# use built in server (sh rfriends3/rf3server.sh) 
export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smb"
export atd="atd"
export cron="cron"

export app_openssh="openssh-server"
export app_cron="cron"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium-browser"
export app_atomicparsley="rpm"
#
sudo zypper refresh
sudo $cmd sysvinit-tools

sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

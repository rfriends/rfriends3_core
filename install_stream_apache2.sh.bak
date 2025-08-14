#!/bin/bash
# =========================================
# Install rfriends and Apache2 on CentOS stream
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2025/08/15
ver=1.0
# -----------------------------------------
echo start $ver
echo
sudo dnf update
if [ $? != 0 ]; then
  echo
  echo install_stream.sh
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
rhel=$(rpm -E %rhel)
echo
echo $rhel
if [ $rhel != "%rhel" ]; then
  echo
  echo RPM Fusion リポジトリを追加
  echo
  #sudo dnf -y install epel-release
  #sudo dnf -y config-manager --set-enabled crb

  sudo dnf -y install https://download.fedoraproject.org/pub/epel/epel-release-latest-$rhel.noarch.rpm
  sudo /usr/bin/crb enable

  sudo dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$rhel.noarch.rpm
  sudo dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$rhel.noarch.rpm

  sudo dnf makecache
fi
# -----------------------------------------
export distro="stream"
export cmd="dnf install -y"

#export user=user
#export group=user
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
export smbd="smb"
export atd="atd"
export cron="crond"

export app_openssh="openssh-server"
export app_cron="cronie"
export app_ffmpeg="ffmpeg-free"
export app_chromium="chromium"
export app_atomicparsley="rpm"
export app_iproute="iproute"
#
sudo dnf update

sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish

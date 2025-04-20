#!/bin/bash
# =========================================
# install rfriends3 for CentOS stream
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2025/04/17
# 1.1 2025/04/19
ver=1.1
# -----------------------------------------
echo start $ver
echo
# タイムゾーンを東京に
timedatectl set-timezone Asia/Tokyo
# -----------------------------------------
# enforceをPermissiveに設定
sudo setenforce 0
# 常に設定したい場合
#sudo sed -i "/^SELINUX=enforcing/c SELINUX=Permissive" /etc/selinux/config

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
#export bindir="/usr/bin"

export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smb"
export atd="atd"
export cron="crond"

export app_openssh="openssh-server"
export app_cron="cronie"
export app_ffmpeg="ffmpeg-free"
export app_chromium="chromium"
export app_atomicparsley="rpm"
#
sudo dnf update
sh common.sh 1> >(tee common.log >&1 ) 2> >(tee common.err >&2)
# -----------------------------------------
# finish

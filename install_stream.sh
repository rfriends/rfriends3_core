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
#grep "^SELINUX=enforcing" /etc/selinux/config> /dev/null
#sudo sed -i "/^SELINUX=enforcing/c SELINUX=Permissive" /etc/selinux/config
sudo setenforce 0

echo
sudo systemctl is-enabled firewalld
if [ $? = 0 ]; then
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
fi
# -----------------------------------------
rpm=$(rpm -E %rhel)
echo
echo $rpm
if [ $rpm != "%rhel" ]; then
  echo
  echo RPM Fusion リポジトリを追加
  echo
  #sudo dnf -y install epel-release
  #sudo dnf -y config-manager --set-enabled crb

  sudo dnf -y install https://download.fedoraproject.org/pub/epel/epel-release-latest-$rpm.noarch.rpm
  sudo /usr/bin/crb enable

  sudo dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$rpm.noarch.rpm
  sudo dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$rpm.noarch.rpm

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

export optlighttpd="on2"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smb"
export atd="atd"
export cron="crond"
#
sudo dnf update
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish

#!/bin/bash
# =========================================
# install rfriends3 for stream9
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2022/03/18
# 1.1 2022/12/22 stream9
# 2.1 2024/12/16 github
# 2.3 2025/01/24 fix
ver=2.3
# -----------------------------------------
echo start $ver
echo
# -----------------------------------------
# enforceをPermissiveに設定
#grep "^SELINUX=enforcing" /etc/selinux/config> /dev/null
#sudo sed -i "/^SELINUX=enforcing/c SELINUX=Permissive" /etc/selinux/config
sudo setenforce 0
# タイムゾーンを東京に
timedatectl set-timezone Asia/Tokyo
# -----------------------------------------
echo
echo RPM Fusion リポジトリを追加
echo
sudo dnf -y install epel-release
sudo dnf -y config-manager --set-enabled crb

#sudo dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y
#sudo dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
# -----------------------------------------
export distro="stream9"
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
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish

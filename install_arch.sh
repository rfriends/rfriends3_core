#!/bin/bash
# =========================================
# install rfriends3 for arch
#
#useradd -m user
#passwd user
#pacman -Syu
#pacman -S sudo vi git
#visudo
#user ALL=(ALL) ALL
# login user
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2025/01/24 new
# 1.1 2025/07/16 disable lighttpd
# 1.2 2025/08/15 enable apach2
# 1.3 2025/08/18 conf_dir
# 1.5 2026/02/12 lighttpd
# 1.7 2026/02/17 systemd schedule
ver=1.7
# -----------------------------------------
echo start $ver
echo
sudo pacman -Syu
if [ $? != 0 ]; then
  echo
  echo install_arch.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
export distro="arch"
export cmd="pacman -S --noconfirm"
export job="systemd"

user=`whoami`
export user=user
#export group=user
#export port=8000
export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export phpdir="/usr/bin"

export optlighttpd="on2b"
#export optapache2="onht"
#export apache_conf_dir="/etc/httpd/conf"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export apache2="httpd"
export smbd="smb"
export atd="atd"
export cron="cronie"

export app_openssh="openssh"
export app_cron="cronie"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium"
export app_atomicparsley="atomicparsley"
export app_iproute="iproute2"
#
sh common.sh 2>common.err | tee common.log
# -----------------------------------------
# firewall
if [ $optsamba -eq "on" ]; then
    sudo firewall-cmd --permanent --add-service=samba
fi
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --reload
#
sudo systemctl start sshd
sudo systemctl enable sshd
# -----------------------------------------
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish

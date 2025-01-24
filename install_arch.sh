#!/bin/bash
# =========================================
# install rfriends3 for arch
#
#useradd -m user
#passwd user
#pacman -Syu
#pacman -S sudo vi
#visudo
#user ALL=(ALL) ALL
# login user
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2025/01/24 new
ver=1.0
# -----------------------------------------
echo start $ver
echo
# -----------------------------------------
#sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# update
sudo pacman -Sy --noconfirm
sudo pacman -Syu --noconfirm

# タイムゾーンを東京に
timedatectl set-timezone Asia/Tokyo
# -----------------------------------------
export distro="arch"
export cmd="pacman -S --noconfirm"

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
export cron="cronie"
#
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish

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
ver=1.0
# -----------------------------------------
echo start $ver
echo
sudo pacman -Syy
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

#export user=user
#export group=user
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export phpdir="/usr/bin"

export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
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
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish

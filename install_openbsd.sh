#!/usr/local/bin/bash
# =========================================
# install rfriends for OpenBSD
# =========================================
# 1.0 2026/06/08 new

ver=1.0
echo start $ver
echo
  echo
  echo 現在開発中のため、正常に動作しません。2026/06/08
  echo
  
sudo pkgin update
if [ $? != 0 ]; then
  echo
  echo install_openbsd.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  #cat /etc/os-release
  uname -a
  exit 1
fi
# -----------------------------------------
doas pkg_add sudo
doas mkdir -p /etc/sudoers.d
echo "%wheel ALL=(ALL) SETENV: ALL" | doas tee /etc/sudoers.d/wheel > /dev/null
doas chmod 0440 /etc/sudoers.d/wheel
# -----------------------------------------
export distro="openbsd"
export cmd="pkg_add"
export cmdupdate="pkg_add -u"

#export user=`whoami`
#export group=$user
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
export PREFIX=""
export phpdir="/usr/localbin/php"

export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export php="83"
export phpv="8.3"
export lighttpd="lighttpd"
export ffmpeg="ffmpeg"
export ffplay="ffplay"
export ffprobe="ffprobe"
# samba4のみ
export samba="samba"
export smbd="smbdr"
export atd="atd"
export cron="cron"
export ipcmd="ifconfig"
#
sh common_openbsd.sh 2>common_openbsd.err | tee common_openbsd.log
echo --- commmon_openbsd.err
cat common_openbsd.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

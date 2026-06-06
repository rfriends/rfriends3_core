#!/usr/local/bin/bash
# =========================================
# install rfriends for NetBSD
# =========================================
# 1.0 2026/06/07 new

ver=1.0
echo start $ver
echo
sudo pkgin update
if [ $? != 0 ]; then
  echo
  echo install_netbsd.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  #cat /etc/os-release
  uname -a
  exit 1
fi
# -----------------------------------------
export distro="netbsd"
export cmd="pkgin -y install"
export cmdupdate="pkgin update"

#export user=`whoami`
#export group=users
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
export PREFIX=""
export phpdir="/usr/pkg/bin/php"

export optlighttpd="on2b"
export optsamba="on"
export optvimrc="off"

export php="php83"
export lighttpd="lighttpd"
export ffmpeg="ffmpeg7"
export ffplay="ffplay7"
# samba4のみ
export samba="samba"
export smbd="smbdr"
export atd="atd"
export cron="cron"
export ipcmd="ifconfig"
#


sh common_netbsd.sh 2>common_netbsd.err | tee common_netbsd.log
echo --- commmon_netbsd.err
cat common_netbsd.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

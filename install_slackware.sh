#!/bin/sh
# =========================================
# install rfriends for slackware
# =========================================
# 1.0 2026/06/11 new

ver=1.0
echo start $ver
echo
  echo
  echo 現在開発中のため、正常に動作しません。2026/06/11
  echo
  
if [ ! -f /etc/slackware-version ]; then
  echo
  echo install_slackware.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
sudo mkdir -p /etc/sudoers.d
echo "%wheel ALL=(ALL) SETENV: ALL" | sudo tee /etc/sudoers.d/wheel > /dev/null
sudo chmod 0440 /etc/sudoers.d/wheel
# -----------------------------------------
# slackpkg
echo -n "[slackpkg] "
if ! command -v slackpkg >/dev/null 2>&1; then
  echo "NOT installed."
  exit 1
f1
# -----------------------------------------
# sbopkg
echo -n "[sbopkg] "
if ! command -v sbopkg >/dev/null 2>&1; then
  echo "NOT installed."
  exit 1
# -----------------------------------------
export distro="slackware"
export cmd=""
export cmdupdate="slackpkg update"

#export user=`whoami`
#export group=$user
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
export PREFIX=""
export phpdir="/usr/bin/php"

#export optlighttpd="on4"
#export optsamba="on"
export optlighttpd="off"
export optsamba="off"
export optvimrc="on"

export php=""
export phpv=""
export lighttpd="lighttpd"
export ffmpeg="ffmpeg"
export ffplay="ffplay"
export ffprobe="ffprobe"
# samba4のみ
export samba="samba"
export smbd="smbdr"
export atd="atd"
export cron="cron"
export ipcmd="/sbin/ifconfig"
#
touch common_slackware.err
sh common_slackware.sh 2>common_slackware.err | tee common_slackware.log
echo --- commmon_slackware.err
cat common_slackware.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

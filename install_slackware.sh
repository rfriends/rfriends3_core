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
sudo /usr/sbin/slackpkg > /dev/null 2>&1
if [ $? != 0 ]; then
  echo "slackpkg NOT installed."
  exit 1
fi
# -----------------------------------------
sudo /usr/sbin/sbopkg -v > /dev/null 2>&1
if [ $? != 0 ]; then
  echo "sbopkg NOT installed."
  exit 1
fi
# -----------------------------------------
sudo sbopkg--yes

OUTPUT=$(sudo slackpkg update 2>&1)
if echo "$OUTPUT" | grep -iq "GPG signature.*failed"; then
    echo " GPGエラーを検出しました。鍵の更新が必要です。"
    echo " sudo slackpkg update gpg を実行してください。"
    exit 1
fi
sudo slackpkg install-new
sudo slackpkg upgrade-all
# -----------------------------------------
export distro="slackware"
export cmd=""
export cmdupdate="slackpkg update"

export user=`whoami`
export group=users
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
export PREFIX=""
export phpdir="/usr/bin/php"

export optlighttpd="on4"
export optsamba="on"
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
export cron="crond"
export ipcmd="/sbin/ifconfig"
#

#sh common_slackware.sh 2>common_slackware.err | tee common_slackware.log

cmd=common_slackware
touch $cmd.err
(sh $cmd.sh 2>&1 1>&3 | tee $cmd.err 1>&2) 3>&1 | tee $cmd.log
echo --- commmon_slackware.err
cat $cmd.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

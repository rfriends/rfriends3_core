#!/bin/bash
# =========================================
# install rfriends3 for CentOS7
# =========================================
# Rfriends (radiko radiru録音ツール)
# 1.0 2025/05/03
ver=1.0
# -----------------------------------------
echo start $ver
echo
sudo yum update
if [ $? != 0 ]; then
  echo
  echo install_centos7.sh
  echo 実行するshを間違っていないか確認してください。
  echo
  cat /etc/os-release
  exit 1
fi
# -----------------------------------------
#echo まず、以下の設定（セキュリティOFF）で実行し、 
#echo うまくいったらセキュリティ設定を行ってください。
#echo SELINUX=Disabled
#echo firewalld disable
#
# SELINUXをDisabledに設定
#sudo sed -i "/^SELINUX=enforcing/c SELINUX=Disabled" /etc/selinux/config

sudo systemctl status firewalld　> /dev/null
if [ $? = 0 ]; then
  sudo systemctl stop firewalld
  sudo systemctl disable firewalld
fi
# -----------------------------------------
echo
echo リポジトリを追加
echo
yum -y install epel-release
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
# -----------------------------------------
export distro="stream"
export cmd="yum install -y"

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
export cron="crond"

export app_openssh="openssh-server"
export app_cron="cronie"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium"
export app_atomicparsley="rpm"
#
sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish

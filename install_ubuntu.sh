#!/bin/bash
# =========================================
# install rfriends for ubuntu
# =========================================
# 1.0 2025/01/03 new
# 1.2 2025/02/26 user,group

ver=1.2
echo start $ver
echo
# -----------------------------------------
export distro="ubuntu"
export cmd="apt-get install -y"
export cmdupdate="apt-get update"

#export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export phpdir="/usr/bin"

export optlighttpd="on"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smbd"
export atd="atd"
export cron="cron"

export app_openssh="openssh-server"
export app_cron="cron"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium-browser"
export app_atomicparsley="atomicparsley"
#
sudo apt-get update
sh common.sh 2>common.err | tee common.log
echo --- commmon.err
cat common.err
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

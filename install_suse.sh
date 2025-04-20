#!/bin/bash
# =========================================
# install rfriends for suse
# =========================================
# 1.0 2025/04/15 new
#
ver=1.0
echo start $ver
echo
# -----------------------------------------
export distro="suse"
export cmd="zypper install -y"
export cmdupdate="zypper update"

#export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""
#export bindir="/usr/bin"

# now lighttpd not supported
# use built in server (sh rfriends3/rf3server.sh) 
export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smb"
export atd="atd"
export cron="cron"

export app_openssh="openssh-server"
export app_cron="cron"
export app_ffmpeg="ffmpeg"
export app_chromium="chromium-browser"
export app_atomicparsley="rpm"
#
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo zypper refresh
sudo zypper update
sudo $cmd sysvinit-tools
sh common.sh 1> >(tee common.log >&1 ) 2> >(tee common.err >&2)
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

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

# now lighttpd not supported
# use built in server (sh rfriends3/rf3server.sh) 
export optlighttpd="on2"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smb"
export atd="atd"
export cron="cron"
#
sudo zypper refresh
sudo zypper update
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

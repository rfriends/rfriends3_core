#!/bin/bash
# =========================================
# install rfriends for alpine
# =========================================
# 1.0 2025/04/15 new
#
ver=1.0
echo start $ver
echo
# -----------------------------------------
export distro="alpine"
export cmd="apk add"
export cmdupdate="apk update"

#export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""

# now lighttpd not supported
# use built in server (sh rfriends3/rf3server.sh) 
export optlighttpd="off"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smb"
export atd="atd"
export cron="cron"
#
sudo apk update
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

#!/bin/bash
# =========================================
# install rfriends for ubuntu
# =========================================
# 1.0 2025/01/03 new
# 1.1 2025/01/24 mod

ver=1.1
echo start $ver
echo
# -----------------------------------------
export distro="ubuntu"
export cmd="apt-get install -y"
export cmdupdate="apt-get update"

#export user=user
#export group=user
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
#export PREFIX=""

export optlighttpd="on"
export optsamba="on"
export optvimrc="on"

export lighttpd="lighttpd"
export smbd="smbd"
export atd="atd"
export cron="cron"
#
sudo apt-get update
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

#!/usr/local/bin/bash
# =========================================
# install rfriends for freeBSD
# =========================================
# 1.0 2025/03/04 new
# 1.1 2025/04/20 bindir

ver=1.1
echo start $ver
echo
# -----------------------------------------
export distro="freebsd"
export cmd="pkg install -y"
export cmdupdate="pkg update"

#export user=`whoami`
#export group=`groups | cut -d ' ' -f 1`
#export port=8000
#export homedir=`sh -c 'cd && pwd'`
export PREFIX=""
export bindir="/usr/local/bin"

export optlighttpd="on2b"
export optsamba="on"
export optvimrc="on"

export php="php84"
export lighttpd="lighttpd"
# samba4のみ
export samba="samba419"
export smbd="samba_server"
export atd="atd"
export cron="cron"
export ipcmd="ifconfig"
#
sudo pkg update
sh common_bsd.sh 2>&1 | tee common_bsd.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

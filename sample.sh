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
distro="ubuntu"
cmd="apt-get"

#user=user
#group=user
#port=8000
#homedir=

#export user
#export group
#export port
#export homedir

optlighttpd="on"
optsamba="on"
optvimrc="on"

export optlighttpd
export optsamba
export optvimrc
#
sh install_rfriends3.sh 2>&1 | tee install_rfriends3.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

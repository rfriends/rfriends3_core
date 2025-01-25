#!/bin/bash
# =========================================
# install rfriends for ubuntu
# only lighttpd
# =========================================
# 1.0 2025/01/03 new
# 1.1 2025/01/24 mod

ver=1.1
echo start $ver
echo
# -----------------------------------------
export distro="ubuntu"
export optlighttpd="on"
sudo apt-get update
sh common.sh 2>&1 | tee common.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------

#!/bin/bash -e
# =========================================
# install rfriends for ubuntu
# =========================================
# 3.0 2023/06/23
# 3.1 2023/07/10 remove chromium-browser
# 3.2 2023/07/12 renew
# 3.3 2023/08/04 add p7zip-full
# 3.4 2024/02/23 full
# 3.5 2024/02/24 add openssh-server
# 3.6 2024/10/29 add webdav
# 3.7 2024/11/04 add dirindex.css
# 4.0 2024/12/13 github
# 4.3 2025/01/02 sub
# 4.4 2025/01/23 renew
# 4.5 2025/02/27 arch
# 4.6 2025/04/15 suse
# 4.7 2025/04/15 alpine
# 4.8 2025/04/18 mod
# 4.9 2025/04/20 bindir
ver=4.9
# -----------------------------------------
echo
echo start install_common $ver
echo `date`
echo
# -----------------------------------------
export curdir=$(cd $(dirname $0);pwd)
#
export SCRIPT=rfriends3_latest_script.zip
# ----------------------------------------- systemd or init
sys=`pgrep -o systemd`
if [ $? -ne 0 ]; then
  sys=0
fi
export sys
# ----------------------------------------- package manager
if [ -z "$distro" ]; then
  #distro="ubuntu"
  echo ディストリビューションが指定されていません。
  exit 1
fi
#
if [ -z "$cmd" ]; then
  export cmd="apt-get install -y"
fi
# ----------------------------------------- 
if [ -z "$port" ]; then
  export port=8000
fi
#
if [ -z "$user" ]; then
  export user=`whoami`
fi
if [ -z "$group" ]; then
  export group=`groups | cut -d " " -f 1`
fi
#
if [ -z $homedir ]; then
  export homedir=`sh -c 'cd && pwd'`
fi
#
if [ -z $PREFIX ]; then
  export PREFIX=""
fi
#
if [ -z $bindir ]; then
  export bindir="/usr/bin"
fi
# ----------------------------------------- option
if [ -z "$optlighttpd" ]; then
  export optlighttpd="off"
fi
if [ -z "$optsamba" ]; then
  export optsamba="off"
fi
if [ -z "$optvimrc" ]; then
  export optvimrc="off"
fi
# ----------------------------------------- service
if [ -z "$atd" ]; then
  export atd="atd"
fi
if [ -z "$cron" ]; then
  export cron="cron"
fi
if [ -z "$lighttpd" ]; then
  export lighttpd="lighttpd"
fi
if [ -z "$smbd" ]; then
  export smbd="smbd"
fi
if [ -z "$ipcmd" ]; then
  export ipcmd="ip a"
fi
# ----------------------------------------- app
if [ -z "$app-openssh" ]; then
  export app-openssh="openssh-server"
fi
if [ -z "$app-cron" ]; then
  export app-cron="cron"
fi
if [ -z "$app-ffmpeg" ]; then
  export app-ffmpeg="ffmpeg"
fi
if [ -z "$app-chromium" ]; then
  export app-chromium="chromium-browser"
fi
if [ -z "$app-atomicparsley" ]; then
  export app-atomicparsley="atomicparsley"
fi
# =========================================
echo
echo install tools
echo
# =========================================
sudo $cmd unzip nano vim at wget curl
sudo $cmd p7zip
sudo $cmd tzdata
sudo $cmd iproute2
sudo $cmd php
sudo $cmd php-cli php-xml php-zip php-mbstring php-json php-curl 
sudo $cmd php-intl
sudo $cmd php-simplexml
sudo $cmd php-ctype
sudo $cmd php-openssl

sudo $cmd $app-openssh
sudo $cmd $app-cron
sudo $cmd $app-ffmpeg
sudo $cmd $app-chromium

# ----------------------------------------- atomicparsley
if [ $app-atomicparsley = "atomicparsley" ]; then
  sudo $cmd atomicparsley
else
  #wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
  sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm
fi
if [ -e /usr/bin/atomicparsley ]; then
  # arch
  sudo ln -s /usr/bin/atomicparsley /usr/bin/AtomicParsley
fi
# =========================================
echo
echo install rfriends3
echo
# =========================================
echo rfriends3
sh rfriends3.sh
#
sh at.sh
#
sh cron.sh
# -----------------------------------------
echo
echo vimrc
echo
# -----------------------------------------
echo vimrc $optvimrc
if [ $optvimrc = "on" ]; then
  sh vimrc.sh
fi
# -----------------------------------------
echo
echo install samba
echo
# -----------------------------------------
echo samba $optsamba
if [ $optsamba = "on" ]; then
  sh samba.sh
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on" ]; then
  sh lighttpd.sh
elif [ $optlighttpd = "on2b" ]; then
  sh lighttpd2b.sh
fi
# =========================================
echo
echo result of install rfriends3
echo
sh result.sh
# -----------------------------------------
# finish
# -----------------------------------------
echo `date`
echo end install common
echo
# -----------------------------------------
exit 0
# -----------------------------------------

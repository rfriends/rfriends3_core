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
#
sys=`pgrep -o systemd`
if [ $? -ne 0 ]; then
  sys=0
fi
export sys
#
export curdir=$(cd $(dirname $0);pwd)
#
export SCRIPT=rfriends3_latest_script.zip
# -----------------------------------------
if [ -z "$distro" ]; then
  #distro="ubuntu"
  echo ディストリビューションが指定されていません。
  exit 1
fi
#
if [ -z "$cmd" ]; then
  export cmd="apt-get install -y"
fi
#
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
# -----------------------------------------
if [ -z "$optlighttpd" ]; then
  export optlighttpd="off"
fi
if [ -z "$optsamba" ]; then
  export optsamba="off"
fi
if [ -z "$optvimrc" ]; then
  export optvimrc="off"
fi
# -----------------------------------------
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
# =========================================
echo
echo install tools common
echo
# =========================================
sudo $cmd unzip nano vim at wget curl
sudo $cmd p7zip
sudo $cmd tzdata
sudo $cmd iproute2
sudo $cmd openssh-server
sudo $cmd php-cli php-xml php-zip php-mbstring php-json php-curl php-intl
sudo $cmd cron
sudo $cmd ffmpeg
sudo $cmd atomicparsley
# -----------------------------------------
echo
echo install tools
echo
# -----------------------------------------
if [ $distro = "arch" ]; then
  sudo $cmd cronie
  sudo $cmd chromium
  sudo $cmd openssh
  sudo $cmd php
  sudo ln -s /usr/bin/atomicparsley /usr/bin/AtomicParsley
elif [ $distro = "centos" ] || [ $distro = "stream" ] || [ $distro = "rocky" ]; then
  sudo $cmd cronie
  sudo $cmd ffmpeg-free
  sudo $cmd chromium
  #wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
  sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm

  #sudo $cmd net-tools dnsutils
elif [ $distro = "suse" ]; then
  # suse
  sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm
  sudo $cmd php-ctype php-openssl
  sudo $cmd sysvinit-tools
  #
  sudo $cmd chromium-browser
elif [ $distro = "alpine" ]; then
  # alpine
  sudo $cmd php-simplexml php-ctype php-openssl
  #
  sudo $cmd cronie
  sudo $cmd chromium
else
  # ubuntu
  sudo $cmd chromium-browser
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
elif [ $optlighttpd = "on2" ]; then
  sh lighttpd2.sh
elif [ $optlighttpd = "on2a" ]; then
  sh lighttpd2a.sh
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

#!/bin/sh
# =========================================
# install rfriends for freebsd
# =========================================
# 1.0 2025/03/05 new
# 1.1 2025/04/18 mod 
#
ver=1.1
# -----------------------------------------
echo
echo start install_common_bsd $ver
echo `date`
echo
# -----------------------------------------
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
  #distro="freebsd"
  echo ディストリビューションが指定されていません。
  exit 1
fi
#
if [ -z "$cmd" ]; then
  export cmd="pkg install -y"
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
  export PREFIX="/usr/local"
fi
# -----------------------------------------
if [ -z "$php" ]; then
  export php="php"
fi
if [ -z "$samba" ]; then
  export samba="samba"
fi
# -----------------------------------------
if [ -z "$optlighttpd" ]; then
  export optlighttpd="off"
fi
if [ -z "$optsamba" ]; then
  optsamba="off"
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
  export ipcmd="ifconfig"
fi
# =========================================
echo
echo install tools
echo
# =========================================
sudo $cmd unzip
sudo $cmd nano
sudo $cmd vim 
sudo $cmd wget
sudo $cmd curl
sudo $cmd 7-zip
sudo $cmd pidof
sudo $cmd ffmpeg
sudo $cmd chromium
sudo $cmd atomicparsley

sudo $cmd $php

sudo $cmd ${php}-extensions
sudo $cmd ${php}-xml 
sudo $cmd ${php}-iconv 
sudo $cmd mod_${php}

sudo $cmd ${php}-mbstring 
sudo $cmd ${php}-gd 
sudo $cmd ${php}-gettext 
sudo $cmd ${php}-zlib 
sudo $cmd ${php}-curl 
sudo $cmd ${php}-zip 
sudo $cmd ${php}-intl

sudo $cmd ${php}-json 
#sed -e s%^\;extension=mbstring%extension=mbstring% $PREFIX/etc/php.ini-production | sudo tee $PREFIX/etc/php.ini
# -----------------------------------------
#sudo $cmd tzdata
#sudo $cmd iproute2
#sudo $cmd openssh
#sudo $cmd cronie
# -----------------------------------------
sudo ln -s /usr/local/bin/atomicparsley /usr/local/bin/AtomicParsley
# =========================================
echo
echo install rfriends3
echo
# =========================================
echo rfriends3
sh rfriends3.sh
#
sh at_bsd.sh
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
  sh samba_bsd.sh
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on3" ]; then
  sh lighttpd_bsd.sh
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

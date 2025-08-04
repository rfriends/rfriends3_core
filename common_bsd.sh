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
if [ -z "$SCRIPT" ]; then
  export SCRIPT=rfriends3_latest_script.zip
fi

if [ -z "$extract" ]; then
  export extract="unzip -q -o "
fi
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
  export PREFIX=""
fi
#
if [ -z $phpdir ]; then
  export phpdir="/usr/local/bin"
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
if [ $user = "root" ]; then
  echo ユーザがrootではインストールできません。
  exit 1
fi
# =========================================
echo
echo set timezone to tokyo
echo
# =========================================
if [ $sys -eq 1 ]; then
  sudo timedatectl set-timezone Asia/Tokyo
else 
  #sudo cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime  
  sudo tzsetup Asia/Tokyo   
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

#sudo $cmd ${php}-json 
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
cat /etc/rc.conf | grep cron_enable > /dev/null
if [ $? = 1 ]; then
  echo 'cron_enable = "YES"' | sudo tee -a  /etc/rc.conf
fi
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
  cat /etc/rc.conf | grep samba_server_enable > /dev/null
  if [ $? = 1 ]; then
    echo 'samba_server_enable = "YES"' | sudo tee -a  /etc/rc.conf
  fi
  sh samba_bsd.sh
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on2b" ]; then
  cat /etc/rc.conf | grep lighttpd_enable > /dev/null
  if [ $? = 1 ]; then
    echo 'lighttpd_enable = "YES"' | sudo tee -a  /etc/rc.conf
  fi
  sudo $cmd lighttpd
  #sudo $cmd php-cgi
  #sudo $cmd fcgi
  #sudo $cmd lighttpd-fastcgi

  export usrlocal="$PREFIX/usr/local"
  export log_root="$PREFIX/var/log/lighttpd"
  export state_dir="$PREFIX/var/run"
  export home_dir="$PREFIX/var/run/lighttpd"
  export conf_dir="$PREFIX$usrlocal/etc/lighttpd"
  export cache_dir="$PREFIX/var/cache/lighttpd"
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

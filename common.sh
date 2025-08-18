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
# 5.0 2025/04/21 app
# 5.1 2025/04/26 /usr/lib/tmpfiles.d/
# 5.2 2025/05/03 atomicparsley
# 5.3 2025/07/18 permitroot
# 5.4 2025/07/24 php-dom
# 5.5 2025/07/28 SCRIPT
# 5.6 2025/07/28 SCRIPT
# 5.7 2025/08/14 apache2
# 5.8 2025/08/18 at,cron
ver=5.8
# -----------------------------------------
echo
echo start install_common $ver
echo `date`
echo
# -----------------------------------------
export curdir=$(cd $(dirname $0);pwd)
#
if [ -z "$SCRIPT" ]; then
  export SCRIPT=rfriends3_latest_script.zip
fi

if [ -z "$extract" ]; then
  export extract="unzip -q -o "
fi
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
if [ -z $phpdir ]; then
  export phpdir="/usr/bin"
fi
# ----------------------------------------- option
if [ -z "$permitroot" ]; then
  export permitroot="off"
fi
if [ -z "$optlighttpd" ]; then
  export optlighttpd="off"
fi
if [ -z "$optapache2" ]; then
  export optapache2="off"
fi
if [ -z "$optsamba" ]; then
  export optsamba="off"
fi
if [ -z "$optvimrc" ]; then
  export optvimrc="off"
fi
if [ -z "$optat" ]; then
  export optat="on"
fi
if [ -z "$optcron" ]; then
  export optcron="on"
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
if [ -z "$apache2" ]; then
  export apache2="apache2"
fi
if [ -z "$smbd" ]; then
  export smbd="smbd"
fi
if [ -z "$ipcmd" ]; then
  export ipcmd="ip a"
fi
# ----------------------------------------- app
if [ -z "$app_openssh" ]; then
  export app_openssh="openssh-server"
fi
if [ -z "$app_cron" ]; then
  export app_cron="cron"
fi
if [ -z "$app_ffmpeg" ]; then
  export app_ffmpeg="ffmpeg"
fi
if [ -z "$app_chromium" ]; then
  export app_chromium="chromium-browser"
fi
if [ -z "$app_atomicparsley" ]; then
  export app_atomicparsley="atomicparsley"
fi
if [ -z "$app_iproute" ]; then
  export app_iproute="iproute2"
fi
# =========================================
if [ $user = "root" ] && [ $permitroot = "off" ]; then
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
  sudo cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime  
fi
# =========================================
echo
echo install tools
echo
echo 共通処理のため、ディストリビューションによりnot found等のエラーが出ます
echo
# =========================================
sudo $cmd unzip nano vim wget curl
#sudo $cmd at
sudo $cmd p7zip
sudo $cmd tzdata

sudo $cmd php
sudo $cmd php-common
sudo $cmd php-cli php-zip php-mbstring php-json php-curl 
sudo $cmd php-ctype
sudo $cmd php-intl
sudo $cmd php-xml
sudo $cmd php-simplexml
sudo $cmd php-openssl
sudo $cmd php-dom

sudo $cmd $app_iproute
sudo $cmd $app_openssh
#sudo $cmd $app_cron
sudo $cmd $app_ffmpeg
if [ $? != 0 ]; then
  sudo $cmd ffmpeg
fi
sudo $cmd $app_chromium
# ----------------------------------------- atomicparsley
ap7=AtomicParsley-0.9.5-13.fc30.x86_64.rpm
ap8=AtomicParsley-0.9.5-16.fc33.x86_64.rpm
ap9=AtomicParsley-0.9.5-19.fc36.x86_64.rpm

ap=0
if [ $app_atomicparsley = "atomicparsley" ]; then
  ap=1
elif [ $app_atomicparsley = "rpm" ]; then
  sudo rpm -i --test $ap7 2> /dev/null
  if [ $? = 0 ]; then
    ap=7
  fi
  sudo rpm -i --test $ap8 2> /dev/null
  if [ $? = 0 ]; then
    ap=8 
  fi
  sudo rpm -i --test $ap9 2> /dev/null
  if [ $? = 0 ]; then
    ap=9
  fi
fi

if [ $ap = 1 ]; then
  echo atomicparsley
  sudo $cmd atomicparsley
elif [ $ap = 7 ]; then
  echo $ap7
  sudo rpm -ivh $ap7
elif [ $ap = 8 ]; then
  echo $ap8
  sudo rpm -ivh $ap8
elif [ $ap = 9 ]; then
  echo $ap9
  sudo rpm -ivh $ap9
else
  echo AtomicParsley not found
fi
# ----------------------------------------- 
if [ ! -e /usr/bin/AtomicParsley ]; then
  # arch
  sudo ln -s /usr/bin/atomicparsley /usr/bin/AtomicParsley
fi
# -----------------------------------------
echo at $optat
if [ $optat = "on" ]; then
  sh at.sh
fi
# -----------------------------------------
echo cron $optcron
if [ $optcron = "on" ]; then
  sh cron.sh
fi
# -----------------------------------------
echo
echo vimrc
echo
# -----------------------------------------
echo vimrc $optvimrc
if [ $optvimrc = "on" ]; then
  sh vimrc.sh
fi
# =========================================
echo
echo install rfriends3
echo
# =========================================
echo rfriends3
sh rfriends3.sh
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
elif [ $optlighttpd = "on1a" ]; then
  sudo $cmd lighttpd php-cgi
  sudo $cmd lighttpd-mod-webdav
  
  export conf_dir="$PREFIX/etc/lighttpd"
  export cache_dir="$PREFIX/var/cache/lighttpd"
  export log_dir="$PREFIX/var/log/lighttpd"

  export php_dir="$PREFIX/usr/bin"
  export pid_dir="$PREFIX/run"
  export socket_dir="$PREFIX/run/lighttpd"
  sh lighttpd1a.sh
elif [ $optlighttpd = "on2b" ]; then
  sudo $cmd lighttpd
  sudo $cmd php-cgi
  #sudo $cmd fcgi
  sudo $cmd lighttpd-fastcgi

  export usrlocal="$PREFIX"
  export log_root="$PREFIX/var/log/lighttpd"
  export state_dir="$PREFIX/run/lighttpd"
  export home_dir="$PREFIX/var/lib/lighttpd"
  export conf_dir="$PREFIX/etc/lighttpd"
  export cache_dir="$PREFIX/var/cache/lighttpd"
  sh lighttpd2b.sh
fi
# -----------------------------------------
echo
echo install apache2
# -----------------------------------------
echo apache2 $optapache2
if [ $optapache2 = "on" ]; then
  export conf_dir="$PREFIX/etc/apache2"
  sh apache2.sh
fi
echo apache2 $optapache2
if [ $optapache2 = "onht" ]; then
  export conf_dir="$PREFIX/etc/httpd/conf"
  sh httpd.sh
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

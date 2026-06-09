#!/bin/sh
# =========================================
# install rfriends for openbsd
# =========================================
# 1.0 2026/06/08
#
ver=1.0
# -----------------------------------------
echo
echo start install_common_openbsd $ver
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
sys=`pgrep systemd`
if [ $? -ne 0 ]; then
  sys=0
fi
export sys
#
export curdir=$(cd $(dirname $0);pwd)
#
# -----------------------------------------
if [ -z "$distro" ]; then
  #distro="openbsd"
  echo ディストリビューションが指定されていません。
  exit 1
fi
#
if [ -z "$cmd" ]; then
  export cmd="pkg_add"
fi
if [ -z "$sucmd" ]; then
  export sucmd="sudo"
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
  #export group=`groups | cut -d " " -f 1`
  export group=$user
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
  export phpdir="/usr/local/bin/php"
fi
# -----------------------------------------
if [ -z "$ffmpeg" ]; then
  export ffmpeg="ffmpeg"
fi
if [ -z "$ffplay" ]; then
  export ffplay="ffplay"
fi
if [ -z "$ffprobe" ]; then
  export ffplay="ffprobe"
fi
if [ -z "$phpv" ]; then
  export phpv="8.3"
fi
if [ -z "$php" ]; then
  export php="83"
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
  $sucmd timedatectl set-timezone Asia/Tokyo
else 
  #$sucmd cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime  
  #$sucmd tzsetup Asia/Tokyo
  $sucmd ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
fi
# =========================================
echo
echo install tools
echo
# =========================================
$sucmd $cmd unzip--
$sucmd $cmd nano
$sucmd $cmd vim--no_x11 
$sucmd $cmd wget
$sucmd $cmd curl
#$sucmd $cmd 7-zip
$sucmd $cmd p7zip
#$sucmd $cmd pidof
$sucmd $cmd $ffmpeg
#$sucmd $cmd $ffplay
$sucmd $cmd chromium
$sucmd $cmd atomicparsley

$sucmd ln -s /usr/local/bin/AtomicParsley /usr/local/bin/atomicparsley
# -----------------------------------------
$sucmd $cmd php%${phpv}

$sucmd $cmd php-gd%${phpv} 
$sucmd $cmd php-curl%${phpv} 
$sucmd $cmd php-zip%${phpv} 
$sucmd $cmd php-intl%${phpv}

$sucmd $cmd libssh2
$sucmd $cmd pecl${php}-ssh2

$sucmd ln -sf /etc/php-${phpv}.sample/gd.ini /etc/php-${phpv}/gd.ini
$sucmd ln -sf /etc/php-${phpv}.sample/curl.ini /etc/php-${phpv}/curl.ini
$sucmd ln -sf /etc/php-${phpv}.sample/zip.ini /etc/php-${phpv}/zip.ini
$sucmd ln -sf /etc/php-${phpv}.sample/intl.ini /etc/php-${phpv}/intl.ini
$sucmd ln -sf /etc/php-${phpv}.sample/ssh2.ini /etc/php-${phpv}/ssh2.ini 


sed -i '' 's/^allow_url_fopen = Off/allow_url_fopen = On/' "/etc/php-${phpv}.ini"
# -----------------------------------------
#$sucmd $cmd tzdata
#$sucmd $cmd iproute2
#$sucmd $cmd openssh
#$sucmd $cmd cronie

$sucmd cp pidof.sh /usr/local/bin/pidof
$sucmd chmod +x /usr/local/bin/pidof
# pidof test
pidof sshd
# =========================================
echo
echo install rfriends3
echo
# =========================================
echo rfriends3
sh rfriends3.sh
#
echo "$user" | sudo tee -a /var/cron/at.allow
sudo chown root:crontab /var/cron/at.allow
sudo chmod 640 /var/cron/at.allow

sudo rcctl enable cron
sudo rcctl start cron
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
  sh samba_openbsd.sh
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on3" ]; then  
  $sucmd $cmd lighttpd--

  export conf_dir="/etc"
  sh lighttpd3.sh
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

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
#
curdir=$(cd $(dirname $0);pwd)
#
SCRIPT=rfriends3_latest_script.zip
# -----------------------------------------
if [ -z "$distro" ]; then
  #distro="freebsd"
  echo ディストリビューションが指定されていません。
  exit 1
fi
#
if [ -z "$cmd" ]; then
  cmd="pkg install -y"
fi
#
if [ -z "$port" ]; then
  port=8000
fi
#
if [ -z "$user" ]; then
  user=`whoami`
fi
if [ -z "$group" ]; then
  group=`groups | cut -d " " -f 1`
fi
#
if [ -z $homedir ]; then
  homedir=`sh -c 'cd && pwd'`
fi
#
if [ -z $PREFIX ]; then
  PREFIX="/usr/local"
fi
# -----------------------------------------
if [ -z "$php" ]; then
  php="php"
fi
if [ -z "$samba" ]; then
  samba="samba"
fi
# -----------------------------------------
if [ -z "$optlighttpd" ]; then
  optlighttpd="off"
fi
if [ -z "$optsamba" ]; then
  optsamba="off"
fi
if [ -z "$optvimrc" ]; then
  optvimrc="off"
fi
# -----------------------------------------
if [ -z "$atd" ]; then
  atd="atd"
fi
if [ -z "$cron" ]; then
  cron="cron"
fi
if [ -z "$lighttpd" ]; then
  lighttpd="lighttpd"
fi
if [ -z "$smbd" ]; then
  smbd="smbd"
fi
if [ -z "$ipcmd" ]; then
  ipcmd="ifconfig"
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
# at
# -----------------------------------------
# atrun 5min -> 2min
cat /etc/cron.d/at | sed s%\^\*/5%\*/2% | sudo tee /etc/cron.d/at
# at.allow
allow=/var/at/at.allow
if [ ! -e $allow ]; then
  # not exist file
  echo $user | sudo tee $allow
else
  grep -w $user $allow
  if [ $? == 1 ]; then
    # not exist user
    echo $user | sudo tee -a $allow
  else
    # exist user
  fi
fi
# -----------------------------------------
# systemd or service
# not exist atd but atrun
# -----------------------------------------
if [ $sys -eq 1 ]; then
  #sudo systemctl enable $atd
  #sudo systemctl start  $atd
  #sudo systemctl status $atd
  sudo systemctl enable $cron
  sudo systemctl start  $cron
  sudo systemctl status $cron
else 
  #sudo service $atd enable
  #sudo service $atd restart
  sudo service $cron enable
  sudo service $cron restart
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

if [ $optlighttpd = "on3" ]; then
  sh lighttpd3.sh
fi
# -----------------------------------------
echo
cat $homedir/rfriends3/_Rfriends3
echo
echo "`cat /etc/os-release | grep PRETTY_NAME`"
echo "distro : $distro"
if [ $sys -eq 1 ]; then
  echo "type : systemd" 
else 
  echo "type : initd"
fi
echo
echo samba    : $optsamba
echo lighttpd : $optlighttpd
echo vimrc    : $optvimrc
echo
echo user  : $user
echo group : $group
echo port  : $port
echo
echo home    directry : $homedir
echo current directry : $curdir
echo PREFIX : $PREFIX
echo
#ip=`hostname -I | cut -d " " -f 1`
ip=`$ipcmd | grep "inet " | grep -v "127.0.0.1" | sed -e 's/^ *//' | cut -d " " -f 2`
echo
echo IP address : $ip

# -----------------------------------------
# finish
# -----------------------------------------
echo `date`
echo end install common
echo
# -----------------------------------------
exit 0
# -----------------------------------------

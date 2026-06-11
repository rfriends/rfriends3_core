#!/bin/sh
# =========================================
# install rfriends for slackwarea
# =========================================
# 1.0 2026/06/11
#
ver=1.0
# -----------------------------------------
echo
echo start install_common_slackware $ver
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
export sys=0

export curdir=$(cd $(dirname $0);pwd)
#
# -----------------------------------------
if [ -z "$distro" ]; then
  #distro="slackware"
  echo ディストリビューションが指定されていません。
  exit 1
fi
#
if [ -z "$cmd" ]; then
  export cmd=""
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
  export phpdir="/usr/bin/php"
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
  export ipcmd="/sbin/ifconfig"
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
$sucmd ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# =========================================
echo
echo install tools
echo
# =========================================
if ! ls /var/log/packages/AtomicParsley-* >/dev/null 2>&1; then
    sudo /usr/sbin/sbopkg -i atomicparsley
fi

if ! ls /var/log/packages/p7zip-* >/dev/null 2>&1; then
    sudo /usr/sbin/sbopkg -i p7zip
fi

# Chromium
# 廃止

sudo ln -s /usr/bin/AtomicParsley /usr/bin/atomicparsley
# -----------------------------------------
/usr/sbin/slackpkg search libssh2 | grep -q '\[ uninstalled \]' && sudo /usr/sbin/slackpkg install libssh2
sudo pecl channel-update pecl.php.net
printf "\n" | sudo pecl install ssh2-1.3.1
grep -q "^extension=ssh2.so" /etc/php.ini || echo "extension=ssh2.so" | sudo tee -a /etc/php.ini
# =========================================
echo
echo install rfriends3
echo
# =========================================
echo rfriends3
sh rfriends3.sh
#
#echo "$user" | sudo tee -a /etc/at.allow
#sudo chown root:crontab /etc/at.allow
#sudo chmod 640 /etc/at.allow
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
  sh samba_slackware.sh
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd
if [ $optlighttpd = "on4" ]; then  
  export conf_dir="/etc/lighttpd"
  sh lighttpd_slackware.sh
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

#!/bin/sh
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
ver=4.4
# -----------------------------------------
echo
echo start install_rfriends3 $ver
echo `date`
echo
#
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
  distro="ubuntu"
fi
#
if [ -z "$cmd" ]; then
  cmd="apt-get"
fi
#
if [ -z "$port" ]; then
  port=8000
fi
#
if [ -z "$user" ]; then
  user=`whoami`
  group=`groups $user | cut -d " " -f 1`
else
  if [ -z "$group" ]; then
    group=$user
  fi
fi
#
if [ -z $homedir ]; then
  homedir=`sh -c 'cd && pwd'`
fi
#
if [ -z $PREFIX ]; then
  PREFIX=""
fi
# -----------------------------------------
if [ -z "$optlighttpd" ]; then
  optlighttpd="on"
fi
if [ -z "$optsamba" ]; then
  optsamba="on"
fi
if [ -z "$optvimrc" ]; then
  optvimrc="on"
fi

if [ "$optlighttpd" != "on" ]; then
  optlighttpd="off"
fi
if [ "$optsamba" != "on" ]; then
  optsamba="off"
fi
if [ "$optvimrc" != "on" ]; then
  optvimrc="off"
fi
# =========================================
echo
echo install tools
echo
# =========================================
sudo $cmd update && sudo $cmd -y upgrade

sudo $cmd -y install unzip nano vim at cron wget curl \
 php-cli \
 php-xml php-zip php-mbstring php-json php-curl php-intl \
 ffmpeg \
 p7zip-full dnsutils iproute2 tzdata \
 atomicparsley
sudo $cmd -y install chromium-browser 
sudo $cmd -y install openssh-server
# -----------------------------------------
# .vimrcを設定する
# -----------------------------------------
echo vimrc $optvimrc

if [ $optvimrc = "on" ]; then
cd $homedir
mv -n .vimrc .vimrc.org
cat <<EOF > .vimrc
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
EOF
chmod 644 .vimrc
fi
# =========================================
echo
echo install rfriends3
echo
# =========================================
echo rfriends3

cd $homedir
cp -f $curdir/$SCRIPT .
unzip -q -o $SCRIPT

mkdir -p tmp
cat <<EOF > rfriends3/config/usrdir.ini
usrdir = "$homedir/rfriends3/usr/"
tmpdir = "$homedir/tmp/"
EOF
# -----------------------------------------
echo
echo install samba
echo
# -----------------------------------------
echo samba $optsamba

if [ $optsamba = "on" ]; then
cd $curdir
sudo $cmd -y install samba
sudo mkdir -p /var/log/samba
sudo chown root:adm /var/log/samba

sudo cp -p $PREFIX/etc/samba/smb.conf $PREFIX/etc/samba/smb.conf.org
sed -e s%rfriendshomedir%$homedir%g smb.conf.skel > smb.conf
sed -i s%rfriendsuser%$user%g smb.conf
sudo cp -p smb.conf $PREFIX/etc/samba/smb.conf
sudo chown root:root $PREFIX/etc/samba/smb.conf

mkdir -p $homedir/smbdir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd

if [ $optlighttpd = "on" ]; then
cd $curdir
sudo $cmd -y install lighttpd lighttpd-mod-webdav php-cgi

sudo cp -p $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf.org
sed -e s%rfriendshomedir%$homedir%g 15-fastcgi-php.conf.skel > 15-fastcgi-php.conf
sudo cp -p 15-fastcgi-php.conf $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf
sudo chown root:root $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf

sudo cp -p $PREFIX/etc/lighttpd/lighttpd.conf $PREFIX/etc/lighttpd/lighttpd.conf.org
sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel > lighttpd.conf
sed -i s%rfriendsuser%$user%g   lighttpd.conf
sed -i s%rfriendsgroup%$group%g lighttpd.conf
sed -i s%rfriendsport%$port%g   lighttpd.conf
sudo cp -p lighttpd.conf $PREFIX/etc/lighttpd/lighttpd.conf
sudo chown root:root $PREFIX/etc/lighttpd/lighttpd.conf

mkdir -p $homedir/lighttpd/uploads/
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php
echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
fi
# -----------------------------------------
# systemd or service
# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable atd
  sudo systemctl enable cron

  if [ $optsamba = "on" ]; then
    sudo systemctl enable smbd
    sudo systemctl restart smbd
  fi

  if [ $optlighttpd = "on" ]; then
    sudo systemctl enable lighttpd
    sudo systemctl restart lighttpd
  fi

else 
  sudo service atd restart
  sudo service cron restart

  if [ $optsamba = "on" ]; then
    sudo service smbd restart
  fi

  if [ $optlighttpd = "on" ]; then
    sudo service lighttpd restart
  fi
fi
# -----------------------------------------
echo
cat $curdir/_Rfriends3
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
ip=`hostname -I | cut -d " " -f 1`
#ip=`ip a | grep "inet " | grep -v "127.0.0.1" | sed -e 's/^ *//' | cut -d " " -f 2`
# -----------------------------------------
# finish
# -----------------------------------------
echo `date`
echo end install_rfriends3
echo
# -----------------------------------------

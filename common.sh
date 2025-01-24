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
ver=4.4
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
  cmd="apt-get install -y"
fi
#
if [ -z "$cmdupdate" ]; then
  cmdupdate="apt-get update"
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
# =========================================
echo
echo install tools common
echo
# =========================================
sudo $cmdupdate
sudo $cmd unzip p7zip nano vim at wget curl tzdata
sudo $cmd iproute2
sudo $cmd cron
sudo $cmd php-cli php-xml php-zip php-mbstring php-json php-curl php-intl

sudo $cmd atomicparsley
sudo $cmd ffmpeg
sudo $cmd openssh-server
# -----------------------------------------
echo
echo install tools
echo
# -----------------------------------------
if [ $distro = "arch" ]; then
  sudo $cmd cronie
  sudo $cmd chromium
  sudo ln -s /usr/bin/atomicparsley /usr/bin/AtomicParsley
elif [ $distro = "centos" ] || [ $distro = "stream9" ]; then
  sudo $cmd cronie 
  sudo $cmd ffmpeg-free
  sudo $cmd chromium
  #sudo $cmd net-tools dnsutils
  
  #wget https://mirror.perchsecurity.com/pub/archive/fedora/linux/releases/36/Everything/x86_64/os/Packages/a/AtomicParsley-0.9.5-19.fc36.x86_64.rpm  
  sudo rpm -ivh AtomicParsley-0.9.5-19.fc36.x86_64.rpm
else
  # ubuntu
  sudo $cmd chromium-browser
fi
# -----------------------------------------
echo
echo vimrc
echo
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
# systemd or service
# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $atd
  sudo systemctl enable $cron
else 
  sudo service $atd restart
  sudo service $cron restart
fi
# -----------------------------------------
echo
echo install samba
echo
# -----------------------------------------
echo samba $optsamba

if [ $optsamba = "on" ]; then
sudo $cmd samba
sudo mkdir -p /var/log/samba
sudo chown root:adm /var/log/samba

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g smb.conf.skel > smb.conf
sed -i s%rfriendsuser%$user%g smb.conf
sudo cp -f smb.conf $PREFIX/etc/samba/smb.conf
sudo chown root:root $PREFIX/etc/samba/smb.conf

mkdir -p $homedir/smbdir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $smbd
  sudo systemctl restart $smbd
  systemctl status $smbd
else 
  sudo service $smbd restart
  service $smbd status
fi
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd

if [ $optlighttpd = "on" ]; then
sudo $cmd lighttpd php-cgi
sudo $cmd lighttpd-mod-webdav

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g 15-fastcgi-php.conf.skel > 15-fastcgi-php.conf
sudo cp -f 15-fastcgi-php.conf $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf
sudo chown root:root $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf

sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel > lighttpd.conf
sed -i s%rfriendsuser%$user%g   lighttpd.conf
sed -i s%rfriendsgroup%$group%g lighttpd.conf
sed -i s%rfriendsport%$port%g   lighttpd.conf
sudo cp -f lighttpd.conf $PREFIX/etc/lighttpd/lighttpd.conf
sudo chown root:root $PREFIX/etc/lighttpd/lighttpd.conf

mkdir -p $homedir/lighttpd/uploads/
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php
echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $lighttpd
  sudo systemctl restart $lighttpd
  systemctl status $lighttpd
else 
  sudo service $lighttpd restart
  service $lighttpd status
fi
fi
# -----------------------------------------
if [ $optlighttpd = "on2" ]; then
sudo $cmd lighttpd php-cgi
sudo $cmd lighttpd-fastcgi

if [ ! -d $PREFIX/etc/lighttpd/conf.d ]; then
  sudo mkdir -p $PREFIX/etc/lighttpd/conf.d
fi

cd $curdir

if [ $distro = "arch" ]; then
  sudo cp -f conf.d/* $PREFIX/etc/lighttpd/conf.d/
fi

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel2 > lighttpd.conf
sed -i s%rfriendsuser%$user%g lighttpd.conf
sed -i s%rfriendsgroup%$group%g lighttpd.conf
sed -i s%rfriendsport%$port%g lighttpd.conf
sudo cp -f lighttpd.conf $PREFIX/etc/lighttpd/lighttpd.conf
sudo chown root:root $PREFIX/etc/lighttpd/lighttpd.conf
#
# modules
sudo cp -f modules.conf.skel2 $PREFIX/etc/lighttpd/modules.conf
sudo chown root:root $PREFIX/etc/lighttpd/modules.conf
#
# fastcgi
sudo cp -f fastcgi.conf.skel2 $PREFIX/etc/lighttpd/conf.d/fastcgi.conf
sudo chown root:root $PREFIX/etc/lighttpd/conf.d/fastcgi.conf
#
# webdav
sudo cp -f webdav.conf.skel2 $PREFIX/etc/lighttpd/conf.d/webdav.conf
sudo chown root:root $PREFIX/etc/lighttpd/conf.d/webdav.conf
cd $homedir/rfriends3/script/html
ln -nfs temp webdav
#
mkdir -p $homedir/lighttpd/uploads/
mkdir -p $homedir/lighttpd/sockets/
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $lighttpd
  sudo systemctl restart $lighttpd
  systemctl status $lighttpd
else 
  sudo service $lighttpd restart
  service $lighttpd status
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
#ip=`hostname -I | cut -d " " -f 1`
ip=`ip a | grep "inet " | grep -v "127.0.0.1" | sed -e 's/^ *//' | cut -d " " -f 2`
echo
echo IP address : $ip

# -----------------------------------------
# finish
# -----------------------------------------
echo `date`
echo end install common
echo
# -----------------------------------------

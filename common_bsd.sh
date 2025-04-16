#!/usr/local/bin/bash -e
# =========================================
# install rfriends for freebsd
# 1.0 2025/03/05
ver=1.0
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
cd $homedir
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
sudo $cmd $samba

#sudo mkdir -p /var/log/samba
#sudo chown root:adm /var/log/samba

cd $curdir/skel_bsd
sed -e s%rfriendshomedir%$homedir%g smb4.conf.skel > smb4.conf
sed -i .bak s%rfriendsuser%$user%g smb4.conf
sudo cp -f smb4.conf $PREFIX/etc/smb4.conf
#sudo chown root:root $PREFIX/etc/smb4.conf

mkdir -p /var/db/samba4/private
mkdir -p /var/log/samba4

sudo chmod 755 /var/run/samba4
sudo chmod 700 /var/db/samba4/private
sudo mkdir /var/run/samba4/fd

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
  sudo service $smbd status
fi
fi
# -----------------------------------------
echo
echo install lighttpd
echo
# -----------------------------------------
echo lighttpd $optlighttpd

if [ $optlighttpd = "on3" ]; then
sudo $cmd lighttpd
#sudo $cmd ${php}-extensions 
#sudo $cmd lighttpd-fastcgi

#if [ ! -d $PREFIX/etc/lighttpd/conf.d ]; then
#  sudo mkdir -p $PREFIX/etc/lighttpd/conf.d
#fi

cd $curdir/skel_bsd
sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel3 > lighttpd.conf
sed -i .bak s%rfriendsuser%$user%g lighttpd.conf
sed -i .bak s%rfriendsgroup%$group%g lighttpd.conf
sed -i .bak s%rfriendsport%$port%g lighttpd.conf
sudo cp -f lighttpd.conf $PREFIX/etc/lighttpd/lighttpd.conf
#sudo chown root:root $PREFIX/etc/lighttpd/lighttpd.conf
#
# modules
sudo cp -f modules.conf.skel3 $PREFIX/etc/lighttpd/modules.conf
#sudo chown root:root $PREFIX/etc/lighttpd/modules.conf
#
# fastcgi
sudo cp -f fastcgi.conf.skel3 $PREFIX/etc/lighttpd/conf.d/fastcgi.conf
#sudo chown root:root $PREFIX/etc/lighttpd/conf.d/fastcgi.conf
#
# webdav
sudo cp -f webdav.conf.skel3 $PREFIX/etc/lighttpd/conf.d/webdav.conf
#sudo chown root:root $PREFIX/etc/lighttpd/conf.d/webdav.conf
cd $homedir/rfriends3/script/html
ln -nfs temp webdav
#
mkdir -p $homedir/lighttpd/uploads/
mkdir -p $homedir/lighttpd/sockets/
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
killall $lighttpd
if [ $sys -eq 1 ]; then
  sudo systemctl enable $lighttpd
  sudo systemctl restart $lighttpd
  sudo systemctl status $lighttpd
else 
  sudo service $lighttpd restart
  sudo service $lighttpd status
fi
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

#!/bin/sh
# lighttpd on2b
# 2025/04/20
#
onver="on2b"

sudo $cmd lighttpd
sudo $cmd php-cgi
#sudo $cmd fcgi
sudo $cmd lighttpd-fastcgi
# -----------------------------------------
# log_root
sudo mkdir -p $PREFIX/var/log/lighttpd
sudo chown $user:$group $PREFIX/var/log/lighttpd

# state_dir
sudo mkdir -p $PREFIX/run/lighttpd
sudo chown $user:$group $PREFIX/run/lighttpd

# home_dir
sudo mkdir -p $PREFIX/var/lib/lighttpd
sudo mkdir -p $PREFIX/var/lib/lighttpd/uploads/
sudo mkdir -p $PREFIX/var/lib/lighttpd/sockets/

sudo chown $user:$group $PREFIX/var/lib/lighttpd
sudo chown $user:$group $PREFIX/var/lib/lighttpd/uploads/
sudo chown $user:$group $PREFIX/var/lib/lighttpd/sockets/

# conf_dir
sudo mkdir -p $PREFIX/etc/lighttpd
sudo chown $user:$group $PREFIX/etc/lighttpd
sudo mkdir -p $PREFIX/etc/lighttpd/conf.d
sudo chown $user:$group $PREFIX/etc/lighttpd/conf.d

# cache_dir
sudo mkdir -p $PREFIX/var/cache/lighttpd
sudo chown $user:$group $PREFIX/var/cache/lighttpd

# -----------------------------------------
cd $curdir
sudo cp -f conf.d/* $PREFIX/etc/lighttpd/conf.d/

cd $curdir/skel

sed -e s%rfriendsserver_root%rfriendshomedir/rfriends3%g lighttpd.conf.skel2b > lighttpd.confa
sed -e s%rfriendshomedir%$homedir%g lighttpd.confa > lighttpd.confb
sed -e s%rfriendsuser%$user%g   lighttpd.confb > lighttpd.confc
sed -e s%rfriendsgroup%$group%g lighttpd.confc > lighttpd.confd
sed -e s%rfriendsport%$port%g   lighttpd.confd > lighttpd.confe

sed -e s%rfriendslog_root%/var/log/lighttpd%g lighttpd.confe > lighttpd.conf1
sed -e s%rfriendsstate_dir%/run/lighttpd%g    lighttpd.conf1 > lighttpd.conf2
sed -e s%rfriendshome_dir%/var/lib/lighttpd%g lighttpd.conf2 > lighttpd.conf3
sed -e s%rfriendsconf_dir%/etc/lighttpd%g     lighttpd.conf3 > lighttpd.conf4
sed -e s%rfriendscache_dir%/var/cache/lighttpd%g lighttpd.conf4 > lighttpd.conf5

sudo cp -f lighttpd.conf5 $PREFIX/etc/lighttpd/lighttpd.conf
#
# modules
sudo cp -f modules.conf.skel2b $PREFIX/etc/lighttpd/modules.conf
#sudo chown root:root $PREFIX/etc/lighttpd/modules.conf
#
# fastcgi
sed -e s%rfriendsphpdir%$phpdir%g fastcgi.conf.skel2b > fastcgi.conf
sudo cp -f fastcgi.conf $PREFIX/etc/lighttpd/conf.d/fastcgi.conf
#sudo chown root:root $PREFIX/etc/lighttpd/conf.d/fastcgi.conf
#
# webdav
sudo cp -f webdav.conf.skel2b $PREFIX/etc/lighttpd/conf.d/webdav.conf
#sudo chown root:root $PREFIX/etc/lighttpd/conf.d/webdav.conf
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt

sudo touch $PREFIX/etc/lighttpd/$onver
# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $lighttpd
  sudo systemctl restart $lighttpd
  systemctl status $lighttpd
else 
  sudo service $lighttpd restart
  service $lighttpd status
fi

exit 0

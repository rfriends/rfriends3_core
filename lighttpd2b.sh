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

sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel2b > lighttpd.conf0
sed -e s%rfriendsuser%$user%g   lighttpd.conf0 > lighttpd.conf1
sed -e s%rfriendsgroup%$group%g lighttpd.conf1 > lighttpd.conf2
sed -e s%rfriendsport%$port%g   lighttpd.conf2 > lighttpd.conf
sudo cp -f lighttpd.conf $PREFIX/etc/lighttpd/lighttpd.conf
#sudo chown root:root $PREFIX/etc/lighttpd/lighttpd.conf
rm lighttpd.conf0
rm lighttpd.conf1
rm lighttpd.conf2
#
# modules
sudo cp -f modules.conf.skel2b $PREFIX/etc/lighttpd/modules.conf
#sudo chown root:root $PREFIX/etc/lighttpd/modules.conf
#
# fastcgi
sed -e s%rfriendsbindir%$PREFIX/$bindir%g fastcgi.conf.skel2b > fastcgi.conf
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

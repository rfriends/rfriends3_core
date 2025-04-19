#!/bin/sh
# lighttpd on2
#
sudo $cmd lighttpd
sudo $cmd php-cgi
sudo $cmd fcgi
sudo $cmd lighttpd-fastcgi

cd $curdir

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel2a > lighttpd.conf
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

sudo mkdir -p $PREFIX/var/log/lighttpd
sudo mkdir -p $PREFIX/var/lib/lighttpd
sudo mkdir -p $PREFIX/var/cache/lighttpd

sudo chown $user:$group $PREFIX/var/log/lighttpd
sudo chown $user:$group $PREFIX/var/lib/lighttpd
sudo chown $user:$group $PREFIX/var/cache/lighttpd

mkdir -p $homedir/lighttpd/uploads/
mkdir -p $homedir/lighttpd/sockets/
#
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

exit 0

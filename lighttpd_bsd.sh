#!/bin/sh
# lighttpd on3
#
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

exit 0


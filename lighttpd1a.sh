#!/bin/sh
# lighttpd on1
#
sudo $cmd lighttpd php-cgi

if [ $distro = "suse" ] || [ $distro = "alpine" ]; then
  sudo $cmd lighttpd-mod_webdav
else
  sudo $cmd lighttpd-mod-webdav
fi

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

exit 0

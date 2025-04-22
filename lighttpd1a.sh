#!/bin/sh
# lighttpd on1a
#
onver=on1a

docroot_dir=$homedir/rfriends3/script/html
conf_dir=$PREFIX/etc/lighttpd

cache_dir=$PREFIX/var/cache/lighttpd
log_dir=$PREFIX/var/log/lighttpd
pid_dir=$PREFIX/run/lighttpd

sudo $cmd lighttpd php-cgi

#if [ $distro = "suse" ] || [ $distro = "alpine" ]; then
#  sudo $cmd lighttpd-mod_webdav
#else
  sudo $cmd lighttpd-mod-webdav
#fi

cd $curdir/skel

sed -e s%rfriendshomedir%$homedir%g 15-fastcgi-php.conf.skel > 15-fastcgi-php.conf
sudo cp -f 15-fastcgi-php.conf $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf
sudo chown root:root $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf

sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel1a > lighttpd.conf0
sed -e s%rfriendsuser%$user%g   lighttpd.conf0 > lighttpd.conf1
sed -e s%rfriendsgroup%$group%g lighttpd.conf1 > lighttpd.conf2
sed -e s%rfriendsport%$port%g   lighttpd.conf2 > lighttpd.conf3
sudo cp -f lighttpd.conf3 $conf_dir/lighttpd.conf
#sudo chown root:root $conf_dir/lighttpd.conf

sudo mkdir -p $cache_dir/uploads
sudo mkdir -p $log_dir
sudo mkdir -p $pid_dir

sudo chown -R $user:$group $cache_dir
sudo chown -R $user:$group $log_dir
sudo chown -R $user:$group $pid_dir

cd $docroot_dir
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
sudo touch $conf_dir/$onver
exit 0

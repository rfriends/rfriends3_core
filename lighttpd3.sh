#!/bin/sh
# lighttpd on3
# 2026/06/09
#
echo "lighttpd on3"
#
onver="on3"
# -----------------------------------------
# directory
sudo mkdir -p /var/www/run
sudo mkdir -p /var/log/lighttpd

# owner
sudo chown -R $user:$group /var/www/run
sudo chown -R $user:$group /var/log/lighttpd

# chmod
doas chmod 755 /var/www
doas chmod 755 /var/www/run
doas chmod 755 /var/log/lighttpd
# -----------------------------------------
cd $curdir/skel

# sed -i は使用しないこと(bsd対策)

sed -e s%rfriendsserver_root%rfriendshomedir/rfriends3%g lighttpd.conf.skel3 > lighttpd.confa
sed -e s%rfriendshomedir%$homedir%g lighttpd.confa > lighttpd.confb
sed -e s%rfriendsuser%$user%g   lighttpd.confb > lighttpd.confc
sed -e s%rfriendsgroup%$group%g lighttpd.confc > lighttpd.confd
sed -e s%rfriendsport%$port%g   lighttpd.confd > lighttpd.confe
sed -e s%rfriendshome_dir%$home_dir%g   lighttpd.confe > lighttpd.conff

sudo cp -f lighttpd.conff $conf_dir/lighttpd.conf

# fpm
sed -e s%rfriendsuser%$user%g   php-fpm.conf.skel3 > php-fpm.confa
sed -e s%rfriendsgroup%$group%g php-fpm.confa > php-fpm.conf

sudo cp -f sudo cp -f php-fpm.conf $conf_dir/php-fpm.conf

# webdav
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
cd $curdir
if [ $sys -eq 1 ]; then
  #sh lighttpd_override.sh
  echo lighttpd_override on
  #sudo systemctl enable $lighttpd
  
  #sudo systemctl status $lighttpd
else 
  sudo rcctl enable php${php}_fpm
  sudo rcctl start  php${php}_fpm
  
  sudo rcctl enable lighttpd
  sudo rcctl start lighttpd
fi

sudo touch $conf_dir/$onver
exit 0

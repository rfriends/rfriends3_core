#!/bin/sh
# Apache2
# 2025/08/14
#
echo "apache2"
#
onver=onap

docroot_dir=$homedir/rfriends3/script/html

cd $curdir/skel_apache

# sed -i は使用しないこと

sed -e s%rfriendshomedir%$homedir%g apache2.conf.skel > apache2.conf
sed -e s%rfriendsuser%$user%g   envvars.skel > envvars
sed -e s%rfriendsport%$port%g ports.conf.skel > ports.conf

sed -e s%rfriendshomedir%$homedir%g 000-default.conf.skel > 000-default.conf1
sed -e s%rfriendsport%$port%g 000-default.conf1 > 000-default.conf

sudo cp -f apache2.conf $conf_dir/apache2.conf
sudo cp -f envvars      $conf_dir/envvars
sudo cp -f ports.conf   $conf_dir/ports.conf

sudo cp -f 000-default.conf $conf_dir/sites-enabled/000-default.conf

cd $homedir/rfriends3/script/html
ln -nfs temp webdav

if [ $sys -eq 1 ]; then
  sudo systemctl enable  $apache2
  sudo systemctl restart $apache2
  sudo systemctl status  $apache2
else 
  sudo service $lighttpd restart
  sudo service $lighttpd enable
  sudo service $lighttpd status
fi
sudo touch $conf_dir/$onver
exit 0

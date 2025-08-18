#!/bin/sh
# httpd for arch
# 2025/08/18
#
echo "httpd"
#
onver=onht-2

docroot_dir=$homedir/rfriends3/script/html

sudo $cmd apache
sudo $cmd php
sudo $cmd php-apache

cd $curdir/skel_apache

# sed -i は使用しないこと

sed -e s%rfriendshomedir%$homedir%g httpd-2.conf.skel > httpd.conf1
sed -e s%rfriendsuser%$user%g httpd.conf1 > httpd.conf2
sed -e s%rfriendsgroup%$group%g httpd.conf2 > httpd.conf3
sed -e s%rfriendsport%$port%g httpd.conf3 > httpd.conf

sudo cp -f httpd.conf $apache_conf_dir/httpd.conf

# webdav

#cd $homedir/rfriends3/script/html
#ln -nfs temp webdav

if [ $sys -eq 1 ]; then
  sudo systemctl enable  $apache2
  sudo systemctl restart $apache2
  sudo systemctl status  $apache2
else 
  sudo service $apache2 restart
  sudo service $apache2 enable
  sudo service $apache2 status
fi
sudo touch $apache_conf_dir/$onver
exit 0

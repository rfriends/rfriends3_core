#!/bin/sh
# httpd for arch
# 2026/05/02
#
echo "httpd"
#
onver=onht

docroot_dir=$homedir/rfriends3/script/html

sudo $cmd apache
sudo $cmd php
sudo $cmd php-apache

cd $curdir/skel_apache

# sed -i は使用しないこと

sed -e s%rfriendshomedir%$homedir%g httpd.conf.skel > httpd.conf1
sed -e s%rfriendsuser%$user%g httpd.conf1 > httpd.conf2
sed -e s%rfriendsgroup%$group%g httpd.conf2 > httpd.conf3
sed -e s%rfriendsport%$port%g httpd.conf3 > httpd.conf

sudo cp -f httpd.conf $apache_conf_dir/httpd.conf

# webdav

#cd $homedir/rfriends3/script/html
#ln -nfs temp webdav

if [ $sys -eq 1 ]; then
  sh httpd_override.sh
  echo httpd_override on
  
  sudo systemctl enable  httpd
  sudo systemctl status  httpd
else 
  sudo service $apache2 restart
  sudo service $apache2 enable
  sudo service $apache2 status
fi
sudo touch $apache_conf_dir/$onver
exit 0

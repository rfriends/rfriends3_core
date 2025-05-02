#!/bin/sh
# lighttpd on1a
# 2025/04/26
#
onver=on1a

docroot_dir=$homedir/rfriends3/script/html

cd $curdir/skel

# sed -i は使用しないこと

sed -e s%rfriendsphpdir%$php_dir%g 15-fastcgi-php.conf.skel1a > 15-fastcgi-php.conf0
sed -e s%rfriendssocketdir%$socket_dir%g 15-fastcgi-php.conf0 > 15-fastcgi-php.conf
sudo cp -f 15-fastcgi-php.conf $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf
sudo chown root:root $PREFIX/etc/lighttpd/conf-available/15-fastcgi-php.conf

sed -e s%rfriendshomedir%$homedir%g lighttpd.conf.skel1a > lighttpd.conf0
sed -e s%rfriendsuser%$user%g   lighttpd.conf0 > lighttpd.conf1
sed -e s%rfriendsgroup%$group%g lighttpd.conf1 > lighttpd.conf2
sed -e s%rfriendsport%$port%g   lighttpd.conf2 > lighttpd.conf3

sed -e s%rfriendscachedir%$cache_dir%g lighttpd.conf3 > lighttpd.conf4
sed -e s%rfriendslogdir%$log_dir%g     lighttpd.conf4 > lighttpd.conf5
sed -e s%rfriendspiddir%$pid_dir%g     lighttpd.conf5 > lighttpd.conf6

sudo cp -f lighttpd.conf6 $conf_dir/lighttpd.conf
#sudo chown root:root $conf_dir/lighttpd.conf

# socket_dir
sudo mkdir $socket_dir
sudo chown $user:$group $socket_dir
echo socket_dir : $socket_dir

# cache_dir
sudo mkdir $cache_dir
sudo mkdir $cache_dir/uploads
sudo mkdir $cache_dir/compress
sudo chown $user:$group $cache_dir
sudo chown $user:$group $cache_dir/uploads
sudo chown $user:$group $cache_dir/compress
echo cache_dir : $cache_dir

# log_dir
sudo mkdir $log_dir
sudo chown $user:$group $log_dir
sudo rm $log_dir/error.log
echo log_dir : $user $group $log_dir

# pid_dir
#sudo mkdir $pid_dir
#sudo chown $user:$group $pid_dir
#echo pid_dir : $pid_dir

cd $docroot_dir
ln -nfs temp webdav

sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
cd $curdir
if [ $sys -eq 1 ]; then
  #tmpfiles
  tf=/usr/lib/tmpfiles.d/lighttpd.conf
  tf2=/usr/lib/tmpfiles.d/lighttpd.tmpfile.conf
  if [ -e $tf2 ]; then
    tf=$tf2
  fi
  
  if [ -e $tf ]; then
   echo "d $socket_dir 0750 $user $group -" > tmpfiles
   echo "d $log_dir 0750 $user $group -" >> tmpfiles
   echo "d $cache_dir 0750 $user $group -" >> tmpfiles
   echo "d $cache_dir/compress 0750 $user $group -" >> tmpfiles
   echo "d $cache_dir/uploads 0750 $user $group -" >> tmpfiles
   sudo cp -f tmpfiles $tf
    echo
    echo make $tf
    echo
  fi
  
  svc=/usr/lib/systemd/system/lighttpd.service
  cat $svc | grep '^ProtectHome=read-only' > /dev/null
  if [ $? = 0 ]; then
    sed -e s%^ProtectHome=read-only%ProtectHome=false% $svc > svc.service
    sudo cp -f svc.service $svc
    echo
    echo ProtectHome=read-only -> false
    echo
    sudo systemctl daemon-reload
  fi
  
  sudo systemctl enable $lighttpd
  if [ $? = 0 ]; then
    for i in {1..5}
    do
      #echo wait 2 secs
      sleep 2
      sudo systemctl restart $lighttpd
      sudo systemctl is-active $lighttpd > /dev/null
      if [ $? = 0 ]; then
        break;
      fi
    done
  fi
  sudo systemctl status $lighttpd
else 
  sudo service $lighttpd restart
  sudo service $lighttpd enable
  sudo service $lighttpd status
fi
sudo touch $conf_dir/$onver
exit 0

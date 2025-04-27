#!/bin/sh
# lighttpd on2b
# 2025/04/25
#
onver="on2b"
# -----------------------------------------
# log_root
sudo mkdir -p $log_root
sudo chown $user:$group $log_root
echo log_root : $user $group $log_root

# state_dir
sudo mkdir -p $state_dir
sudo chown $user:$group $state_dir
echo state_dir : $user $group $state_dir

# home_dir
sudo mkdir -p $home_dir
sudo mkdir -p $home_dir/uploads/
sudo mkdir -p $home_dir/sockets/

sudo chown $user:$group $home_dir
sudo chown $user:$group $home_dir/uploads/
sudo chown $user:$group $home_dir/sockets/
echo home_dir : $user $group $home_dir

# conf_dir
sudo mkdir -p $conf_dir
sudo chown $user:$group $conf_dir
sudo mkdir -p $conf_dir/conf.d
sudo chown $user:$group $conf_dir/conf.d
echo conf_dir : $user $group $conf_dir

# cache_dir
sudo mkdir -p $cache_dir
sudo chown $user:$group $cache_dir
echo cache_dir : $user $group $cache_dir
# -----------------------------------------
cd $curdir
sudo cp -f conf.d/* $conf_dir/conf.d/

cd $curdir/skel

# sed -i は使用しないこと

sed -e s%rfriendsserver_root%rfriendshomedir/rfriends3%g lighttpd.conf.skel2b > lighttpd.confa
sed -e s%rfriendshomedir%$homedir%g lighttpd.confa > lighttpd.confb
sed -e s%rfriendsuser%$user%g   lighttpd.confb > lighttpd.confc
sed -e s%rfriendsgroup%$group%g lighttpd.confc > lighttpd.confd
sed -e s%rfriendsport%$port%g   lighttpd.confd > lighttpd.confe

sed -e s%rfriendslog_root%$log_root%g   lighttpd.confe > lighttpd.conf1
sed -e s%rfriendsstate_dir%$state_dir%g lighttpd.conf1 > lighttpd.conf2
sed -e s%rfriendshome_dir%$home_dir%g   lighttpd.conf2 > lighttpd.conf3
sed -e s%rfriendsconf_dir%$conf_dir%g   lighttpd.conf3 > lighttpd.conf4
sed -e s%rfriendscache_dir%$cache_dir%g lighttpd.conf4 > lighttpd.conf5

sudo cp -f lighttpd.conf5 $conf_dir/lighttpd.conf
#
# modules
sudo cp -f modules.conf.skel2b $conf_dir/modules.conf
#sudo chown root:root $conf_dir/modules.conf
#
# fastcgi
sed -e s%rfriendsphpdir%$PREFIX$phpdir%g fastcgi.conf.skel2b > fastcgi.conf
sudo cp -f fastcgi.conf $conf_dir/conf.d/fastcgi.conf
#sudo chown root:root $conf_dir/conf.d/fastcgi.conf
#
# webdav
sudo cp -f webdav.conf.skel2b $conf_dir/conf.d/webdav.conf
#sudo chown root:root $conf_dir/conf.d/webdav.conf
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
cd $curdir
if [ $sys -eq 1 ]; then
  svc=/usr/lib/systemd/system/lighttpd.service
  cat $svc | grep '^ProtectHome=read-only' > /dev/null
  if [ $? = 0 ]; then
    sed -e s%^ProtectHome=read-only%ProtectHome=false% $svc > svc.service
    sudo cp -f svc.service $svc
    sudo systemctl daemon-reload
    echo
    echo ProtectHome=read-only -> false
    echo
  fi
  sudo systemctl enable $lighttpd
  sudo systemctl restart $lighttpd
  systemctl status $lighttpd
else 
  sudo service $lighttpd enable
  sudo service $lighttpd restart
  service $lighttpd status
fi

sudo touch $conf_dir/$onver
exit 0

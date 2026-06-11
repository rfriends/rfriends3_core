#!/bin/sh
# lighttpd on4
# 2026/06/11
#
echo "lighttpd_slackware on4"
#
onver="on4"
# -----------------------------------------
if ! ls /var/log/packages/lighttpd-* >/dev/null 2>&1; then
  sudo /usr/sbin/groupadd -g 208 lighttpd
  sudo /usr/sbin/useradd -u 208 -g lighttpd -d /var/www lighttpd
  sudo PATH="/usr/sbin:/usr/bin:/sbin:/bin" sbopkg -B -i lighttpd
fi
# -----------------------------------------
sudo chown -R $user:$group /var/log/lighttpd
sudo chown -R $user:$group /var/run/lighttpd
sudo chown -R $user:$group /var/cache/lighttpd

sudo chmod 750 /var/log/lighttpd
sudo chmod 755 /var/run/lighttpd
sudo chmod 750 /var/cache/lighttpd
# -----------------------------------------
cd $curdir/skel

sed -e s%rfriendsserver_root%rfriendshomedir/rfriends3%g lighttpd.conf.skel4 > lighttpd.conf
sed -i s%rfriendshomedir%$homedir%g lighttpd.conf
sed -i s%rfriendsuser%$user%g   lighttpd.conf
sed -i s%rfriendsgroup%$group%g lighttpd.conf
sed -i s%rfriendsport%$port%g   lighttpd.conf
sed -i s%rfriendspid%$pidfile%g     lighttpd.conf
sed -i s%rfriendshome_dir%$home_dir%g   lighttpd.conf

sudo cp -f lighttpd.conf $conf_dir/lighttpd.conf

# webdav
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
cd $curdir

rclocal='/etc/rc.d/rc.local'
if ! grep -q 'rc.lighttpd' "$rclocal"; then
sudo tee -a "$rclocal" <<EOF >/dev/null
if [ -x /etc/rc.d/rc.lighttpd ]; then
  /etc/rc.d/rc.lighttpd start
fi
EOF
fi

if ! grep -q "^PIDFILE=/var/run/lighttpd.pid$" /etc/rc.d/rc.lighttpd; then
  sudo sed -i 's|^PIDFILE=.*|PIDFILE=/var/run/lighttpd.pid|' /etc/rc.d/rc.lighttpd
fi

sudo chmod +x /etc/rc.d/rc.lighttpd
sudo /etc/rc.d/rc.lighttpd stop
sudo /etc/rc.d/rc.lighttpd start

sudo touch $conf_dir/$onver
exit 0

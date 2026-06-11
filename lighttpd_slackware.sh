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

# sed -i は使用しないこと(bsd対策)

sed -e s%rfriendsserver_root%rfriendshomedir/rfriends3%g lighttpd.conf.skel4 > lighttpd.confa
sed -e s%rfriendshomedir%$homedir%g lighttpd.confa > lighttpd.confb
sed -e s%rfriendsuser%$user%g   lighttpd.confb > lighttpd.confc
sed -e s%rfriendsgroup%$group%g lighttpd.confc > lighttpd.confd
sed -e s%rfriendsport%$port%g   lighttpd.confd > lighttpd.confe
sed -e s%rfriendshome_dir%$home_dir%g   lighttpd.confe > lighttpd.conff

sudo cp -f lighttpd.conff $conf_dir/lighttpd.conf

# webdav
cd $homedir/rfriends3/script/html
ln -nfs temp webdav

echo lighttpd > $homedir/rfriends3/rfriends3_boot.txt
# -----------------------------------------
cd $curdir

rclocal='/etc/rc.local'
if ! grep -q 'rc.lighttpd' "$rclocal"; then
sudo tee "$rclocal" <<EOF >/dev/null
if [ -x /etc/rc.d/rc.lighttpd ]; then
  /etc/rc.d/rc.lighttpd start
fi
EOF
fi

sudo chmod +x /etc/rc.d/rc.lighttpd
sudo /etc/rc.d/rc.lighttpd stop
sudo /etc/rc.d/rc.lighttpd start

sudo touch $conf_dir/$onver
exit 0

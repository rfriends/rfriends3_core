#!/bin/sh
# samba
#
sudo $cmd samba
sudo mkdir -p /var/log/samba
sudo chown root:adm /var/log/samba

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g smb.conf.skel > smb.conf
sed -i s%rfriendsuser%$user%g smb.conf
sudo cp -f smb.conf $PREFIX/etc/samba/smb.conf
sudo chown root:root $PREFIX/etc/samba/smb.conf

mkdir -p $homedir/smbdir/usr2/
cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $smbd
  sudo systemctl restart $smbd
  systemctl status $smbd
else 
  sudo service $smbd restart
  service $smbd status
fi

exit 0

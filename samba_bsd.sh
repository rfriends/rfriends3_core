#!/bin/sh
# samba
#
sudo $cmd $samba

#sudo mkdir -p /var/log/samba
#sudo chown root:adm /var/log/samba

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g smb4.conf.skel > smb4.conf0
sed -e s%rfriendsuser%$user%g smb4.conf0 > smb4.conf
sudo cp -f smb4.conf /usr/local/etc/smb4.conf
#sudo chown root:root /usr/local/etc/smb4.conf
rm smb4.conf0

mkdir -p /var/db/samba4/private
mkdir -p /var/log/samba4

sudo chmod 755 /var/run/samba4
sudo chmod 700 /var/db/samba4/private
sudo mkdir /var/run/samba4/fd

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
  sudo service $smbd status
fi

exit 0

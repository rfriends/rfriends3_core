#!/bin/sh
# samba
#
# 1.0 2026/06/08 /usr/local/etc/smb4.conf

sudo $cmd $samba

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g smb4.conf.skel > smb4.conf0
sed -e s%rfriendsuser%$user%g smb4.conf0 > smb4.conf

if [ $distro = "netbsd" ]; then
  sudo cp -f smb4.conf $PREFIX/usr/pkg/etc/samba/smb.conf
fi
if [ $distro = "openbsd" ]; then
  sudo cp -f smb4.conf $PREFIX/usr/local/etc/samba/smb.conf
fi
rm smb4.conf0

mkdir -p $homedir/smbdir/usr2/

cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

# -----------------------------------------
if [ $sys -eq 1 ]; then
  sudo systemctl enable $smbd
  sudo systemctl restart $smbd
  sudo systemctl status $smbd
else 
  if [ $distro = "netbsd" ]; then
    sudo cp /usr/pkg/share/examples/rc.d/smbd /etc/rc.d/
    sudo /etc/rc.d/smbd start
    sudo /etc/rc.d/smbd status
 elif [ $distro = "openbsd" ]; then
    sudo cp /usr/local/share/examples/rc.d/smbd /etc/rc.d/
    sudo /etc/rc.d/smbd start
    sudo /etc/rc.d/smbd status
 else
    sudo service $smbd enable
    sudo service $smbd restart
    sudo service $smbd status
  fi
fi

exit 0

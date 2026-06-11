#!/bin/sh
# samba for slackware
#
# 1.0 2026/06/12 /etc/smb4.conf

# -----------------------------------------
if ! ls /var/log/packages/samba-* >/dev/null 2>&1; then
    sudo /usr/sbin/sbopkg -i samba
fi
# -----------------------------------------

cd $curdir/skel
sed -e s%rfriendshomedir%$homedir%g smb4.conf_slackware.skel > smb4.conf0
sed -e s%rfriendsuser%$user%g smb4.conf0 > smb4.conf
sudo cp -f smb4.conf $PREFIX/etc/samba/smb.conf
rm smb4.conf0

mkdir -p $homedir/smbdir/usr2/

cat <<EOF > $homedir/rfriends3/config/usrdir.ini
usrdir = "$homedir/smbdir/usr2/"
tmpdir = "$homedir/tmp/"
EOF

# -----------------------------------------
sudo chmod +x /etc/rc.d/rc.samba
sudo /etc/rc.d/rc.samba start

exit 0

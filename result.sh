#!/bin/sh
# resukt
#
# =========================================
# reslt of install rfriends3
# =========================================
cat $homedir/rfriends3/_Rfriends3
echo
echo "`cat /etc/os-release | grep PRETTY_NAME`"
echo "distro : $distro"
if [ $sys -eq 1 ]; then
  echo "type : systemd" 
else 
  echo "type : initd"
fi
echo "pkg : $cmd"
echo
echo vimrc    : $optvimrc
echo samba    : $optsamba
echo lighttpd : $optlighttpd
echo
echo user  : $user
echo group : $group
echo port  : $port
echo
echo home    directry : $homedir
echo current directry : $curdir
echo PREFIX : $PREFIX
echo phpdir : $phpdir
echo
#ip=`hostname -I | cut -d " " -f 1`
ip=`$ipcmd | grep "inet " | grep -v "127.0.0.1" | sed -e 's/^ *//' | cut -d " " -f 2`
echo
echo IP address : $ip
echo
exit 0

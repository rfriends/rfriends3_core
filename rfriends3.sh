#!/bin/sh
# rfriends3
#
cd $homedir
cp -f $curdir/$SCRIPT .
#unzip -q -o $SCRIPT
$extract  $SCRIPT

mkdir -p tmp
cat <<EOF > rfriends3/config/usrdir.ini
usrdir = "$homedir/rfriends3/usr/"
tmpdir = "$homedir/tmp/"
EOF
# -----------------------------------------
# systemd or service
# -----------------------------------------
#if [ $sys -eq 1 ]; then
#  sudo systemctl enable $atd
#  sudo systemctl enable $cron
#  sudo systemctl start $atd
#  sudo systemctl start $cron
#else 
#  sudo service $atd restart
#  sudo service $cron restart
#fi
exit 0

#!/bin/sh
# cron
#

if [ $distro = "netbsd" ]; then
# 10 -> 1
  sudo crontab -l | sed 's|^\*/10\(.*/usr/libexec/atrun\)|*\1|' | sudo crontab -
  sudo crontab -l | grep atrun
else
  sudo $cmd $app_cron
fi
#
if [ $sys -eq 1 ]; then
  sudo systemctl enable $cron
  sudo systemctl start  $cron
  sudo systemctl status $cron
else 
  if [ $distro != "netbsd" ]; then
    sudo /etc/rc.d/cron restart
    sudo /etc/rc.d/cron status
  else
    sudo /etc/rc.d/cron start
    sudo /etc/rc.d/cron status
  fi
fi
exit 0

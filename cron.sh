#!/bin/sh
# cron
#
if [ $distro = "netbsd" ]; then
  # 10 -> 1
  sudo crontab -l | sed 's|^\*/10\(.*/usr/libexec/atrun\)|*\1|' | sudo crontab -
  sudo crontab -l | grep atrun
  sudo /etc/rc.d/cron restart
  sudo /etc/rc.d/cron status
  exit 0
fi

sudo $cmd $app_cron
#
if [ $sys -eq 1 ]; then
  sudo systemctl enable $cron
  sudo systemctl start  $cron
  sudo systemctl status $cron
else 
  sudo service $cron restart
  sudo service $cron status
fi
exit 0

#!/bin/sh
# cron
#
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

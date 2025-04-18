#!/bin/sh
# cron
#
if [ $sys -eq 1 ]; then
  sudo systemctl enable $cron
  sudo systemctl start  $cron
  sudo systemctl status $cron
else 
  sudo service $cron enable
  sudo service $cron restart
fi
exit 0

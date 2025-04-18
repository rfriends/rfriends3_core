#!/bin/sh
# at
#
if [ $sys -eq 1 ]; then
  sudo systemctl enable $atd
  sudo systemctl start  $atd
  sudo systemctl status $atd
else 
  sudo service $atd enable
  sudo service $atd restart
fi

exit 0

#!/bin/sh
# at
#
echo --- at-start ( $cmd at )
sudo $cmd at
#
if [ $sys -eq 1 ]; then
  sudo systemctl enable $atd
  sudo systemctl start  $atd
  sudo systemctl status $atd
else 
  sudo service $atd restart
  sudo service $atd status
fi

exit 0

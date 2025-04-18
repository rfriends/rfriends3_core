#!/bin/sh
# at for bsd
## -----------------------------------------
# at
# -----------------------------------------
# atrun 5min -> 2min
cat /etc/cron.d/at | sed s%\^\*/5%\*/2% | sudo tee /etc/cron.d/at
# at.allow
allow=/var/at/at.allow
if [ ! -e $allow ]; then
  # not exist file
  echo $user | sudo tee $allow
else
  grep -w $user $allow
  if [ $? == 1 ]; then
    # not exist user
    echo $user | sudo tee -a $allow
  else
    # exist user
  fi
fi
# -----------------------------------------
# systemd or service
# not exist atd but atrun
# -----------------------------------------
if [ $sys -eq 1 ]; then
  #sudo systemctl enable $atd
  #sudo systemctl start  $atd
  #sudo systemctl status $atd
  sudo systemctl enable $cron
  sudo systemctl start  $cron
  sudo systemctl status $cron
else 
  #sudo service $atd enable
  #sudo service $atd restart
  sudo service $cron enable
  sudo service $cron restart
fi

exit 0

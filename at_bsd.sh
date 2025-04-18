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

exit 0

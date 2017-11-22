#!/bin/bash

LOG_FILE=/srv/logs/data.log

while [ ! -f $LOG_FILE ]
do
  echo "Waiting for log file to be created"
  sleep 1
done

#Give other container some time to finish writing to the log,
#othervise we can end up with duplicated issues in report
sleep 5

goaccess --no-global-config --config-file=/srv/data/goaccess.conf --log-file=$LOG_FILE

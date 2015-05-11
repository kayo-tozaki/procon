#!/bin/bash
# required package: inotify-tools
psout_dir=./STOCK
#m_account=aki-yam

events=(-e CREATE -e MODIFY -e MOVED_TO)
while inotifywait ${events[@]} $psout_dir; do
  #psfile=$psout_dir/`ls -rt $psout_dir | tail -n1`
  #echo "ok,actionning $DATE" > result
  bash ./run.sh & 
done

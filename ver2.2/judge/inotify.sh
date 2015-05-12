#!/bin/bash
# required package: inotify-tools
psout_dir=./STOCK
#m_account=aki-yam

events=(-e CREATE -e MODIFY -e MOVED_TO)
while inotifywait ${events[@]} $psout_dir; do
	while read stock; do
		counter=$stock
	done < $psout_dir
	while [[ $counter -gt 0 ]]; do
		echo $counter
		counter=`expr $counter - 1`
		bash ./run.sh
		echo $counter > $psout_dir
		while read stock; do
			counter=$stock
		done < $psout_dir
	done
  #psfile=$psout_dir/`ls -rt $psout_dir | tail -n1`
  #echo "ok,actionning $DATE" > result
  #bash ./run.sh & 
done

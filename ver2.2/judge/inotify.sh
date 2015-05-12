#!/bin/bash
# required package: inotify-tools
psout_dir=STOCK
File=STOCK
#m_account=aki-yam
events=(-e CREATE -e MODIFY -e MOVED_TO)
while /usr/local/bin/inotifywait ${events[@]} $psout_dir; do
	counter=`cat STOCK`
	while [[ $counter -gt 0 ]]; do
		echo $counter
		counter=`expr $counter - 1`
		bash ./run.sh
		echo $counter > $File
		while read stock; do
			counter=$stock
		done < $File
	done
  #psfile=$psout_dir/`ls -rt $psout_dir | tail -n1`
  #echo "ok,actionning $DATE" > result
  #bash ./run.sh & 
done

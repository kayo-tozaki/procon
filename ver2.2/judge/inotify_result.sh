#!/bin/bash
# required package: inotify-tools
psout_dir=Result
File=Result
#m_account=aki-yam
events=(-e CREATE -e MODIFY -e MOVED_TO)
while /usr/local/bin/inotifywait ${events[@]} $psout_dir; do
	isable=`ps ax |grep "[r]uby"|grep "[c]reate_result_test"|awk '{print $1}'|sed -s 's/[^0-9]//g'`
	if [[ ! $isable -gt 0 ]]; then
	counter=`cat STOCK`
	#TODO:同時実行処理
	while [[ $counter -gt 0 ]]; do
		echo $counter
		counter=`expr $counter - 1`
		echo $counter > $File
		bash ./create_result/run_result.sh
		while read stock; do
			counter=$stock
		done < $File
	done
	else
		sleep 1
	fi
  #psfile=$psout_dir/`ls -rt $psout_dir | tail -n1`
  #echo "ok,actionning $DATE" > result
  #bash ./run.sh & 
done

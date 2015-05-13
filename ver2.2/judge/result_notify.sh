#!/bin/bash
# required package: inotify-tools
DATE=`date +"%s"`
psout_dir=Result
File=Result
#m_account=aki-yam
events=(-e CREATE -e MODIFY -e MOVED_TO)
while /usr/local/bin/inotifywait ${events[@]} $psout_dir; do
	isable=`ps ax |grep "[r]uby"|grep "[c]reate_result_test"|awk '{print $1}'|sed -s 's/[^0-9]//g'`
	if [[ ! $isable -gt 0 ]]; then
	counter=`cat Result`
	#TODO:同時実行処理
	#while [[ $counter -gt 0 ]]; do
		#echo $counter
		#counter=`expr $counter - 1`
		echo $counter > $File
		while read stock; do
			counter=$stock
		done < $File
		echo $counter
		echo `pwd`
		ruby create_result/create_result_test.rb $counter 1> ../log/$counter\_CreateResult.log 2> ../log/$counter\_CRrunError.log 
	#done
	else
		sleep 1
	fi
  #psfile=$psout_dir/`ls -rt $psout_dir | tail -n1`
  #echo "ok,actionning $DATE" > result
  #bash ./run.sh & 
done

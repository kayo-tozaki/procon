#!/bin/bash
# required package: inotify-tools
psout_dir=STOCK
File=STOCK
#m_account=aki-yam
events=(-e CREATE -e MODIFY -e MOVED_TO)
flag=1

#この下が、inotifywait-tool で待機になる部分。
while /usr/local/bin/inotifywait ${events[@]} $psout_dir; do
	isable=`ps ax |grep "[r]uby"|grep "[m]ain"|awk '{print $1}'|sed -s 's/[^0-9]//g'`
	if [[ ! $isable -gt 0 ]]; then		#ジャッジシステムを同時実行をさせないようにする。
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
	else
		sleep 1
	fi
done

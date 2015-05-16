#!/bin/bash
isable=`ps ax |grep "[i]notify"|grep bash|awk '{print $1}'|sed -s 's/[^0-9]//g'`

if [[ ! $isable -gt 0 ]]; then  #すでに inotify.sh が起動している場合は、動かさない。
	cd /var/www/html/ver2.2/judge	#環境変数
	bash inotify.sh & >> /var/www/html/ver2.2/log/crontab.log 
	flag=1
	#STOCKを叩きなおして、inotifywait-toolを動かす。
	if [[ $flag -ne 0 ]]; then
		while read stock; do
			counter=$stock
		done < $File
		counter=`cat STOCK`
		echo $counter > STOCK
		flag=0
	fi
fi
#!/bin/bash
isable=`ps ax |grep "[i]notify"|grep bash|awk '{print $1}'|sed -s 's/[^0-9]//g'`
#echo $isable
if [[ ! $isable -gt 0 ]]; then
	#echo "inport"
	cd /var/www/html/ver2.2/judge	#環境変数
	bash inotify.sh & >> /var/www/html/ver2.2/log/crontab.log 
	counter=`cat STOCK`
	echo $counter > STOCK
	#echo "startup"
fi
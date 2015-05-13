#DATE=`date +"%s"`
cd /var/www/html/ver2.2/judge
# File=Time
# while read stock; do
# 	DATE=$stock
# done < $File
DATE=`cat Time`
# echo "start judge.rb" > ../log/$DATE\_judge.log | /usr/local/rbenv/shims/ruby judge_test.
#count=`ps -ef | grep "ruby" | grep "judge"| wc -l`
#if [ $count = 0 ]; then
#    echo "<br>Already runned"
    /usr/local/rbenv/shims/ruby judge_test.rb 1> ../log/$DATE\_judge.log 2> ../log/$DATE\_runError.log || echo "error" >> ../log/$DATE\_runError.log
#else
#     echo "<br>Will run. please wailt..."
#     tmp=`expr $STOCK + 1`
#     export STOCK=$tmp
#     echo $STOCK
# fi



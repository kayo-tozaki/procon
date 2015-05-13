DATE=`date +"%s"`
# echo "start judge.rb" > ../log/$DATE\_judge.log | /usr/local/rbenv/shims/ruby judge_test.
#count=`ps -ef | grep "ruby" | grep "judge"| wc -l`
#if [ $count = 0 ]; then
#    echo "<br>Already runned"
    /usr/local/rbenv/shims/ruby ./create_result/create_result_test.rb 1> ../log/$DATE\_CreateResult.log 2> ../log/$DATE\_CRrunError.log 
#     echo "<br>Will run. please wailt..."
#     tmp=`expr $STOCK + 1`
#     export STOCK=$tmp
#     echo $STOCK
# fi



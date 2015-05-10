DATE=`date +"%s"`
#echo "start judge.rb" > ../log/$DATE\_judge.log | /usr/local/rbenv/shims/ruby judge_test.
/usr/local/rbenv/shims/ruby judge_test.rb 1> ../log/$DATE\_judge.log 2> ../log/$DATE\_runError.log || echo "error" >> ../log/$DATE\_runError.log

DATE=`date +"%y%m%d"`

echo "Delete tables on DB"
FLAG=`mysql -uroot -e "drop table submit.submit_$DATE;"`
#echo $FLAG
if [[ -n "$FLAG"  ]]; then
	echo "table,not found"
else
	echo "create user "
	mysql -uroot -e "drop table submit.submit_$DATE;" && echo "Comp" || echo "faild creanup DB"
fi

DATE=`date +"%y%m%d"`
FLAG=`mysql -uroot -e "show tables from submit like 'submit_$DATE'"`
#echo mysql -uroot -e "show tables from submit like 'submit_$DATE'"
 if [[ -n $FLAG ]]; then
 	echo "table was already created"
 else
 	mysql -uroot -e "create table submit.submit_$DATE(post_time bigint ,team_name varchar(20),problem_num int,language int,status int,part_point int);"&& echo "table create comp" || echo "faild create table"
 	mysql -uroot -e "GRANT ALL ON submit.* to procon@localhost;" && echo "comp set grant" || echo "faild grant"
fi

FLAG=`mysql -uroot -e "show tables from questions like 'question_$DATE'"`
#echo mysql -uroot -e "show tables from submit like 'submit_$DATE'"
 if [[ -n $FLAG ]]; then
 	echo "table was already created"
 else
 	mysql -uroot -e "create table questions.question_$DATE(question varchar(2) ,time int,mem bigint,testcase int,preci int);"&& echo "table create comp" || echo "faild create table"
 	mysql -uroot -e "GRANT ALL ON questions.* to procon@localhost;" && echo "comp set grant" || echo "faild grant"
fi

#core ファイル2種類を空っぽにして、再度生成(ruby ワンパン)

#問題コンフィグファイルの削除(judge内)
#submitファイル削除
#logファイルの削除

echo "remake result html"
cd ./judge/create_result
echo " " > HTMLcore.txt
echo " " > Screen_core.txt
cd ../
ruby create_result/create_result_test.rb

cd ../submit_file

echo "delete submit files"
rm * 

cd ../log
echo "delete logs"

rm * 

echo "echo complete"


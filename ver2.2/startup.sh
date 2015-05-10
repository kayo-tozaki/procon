echo "各種サービスの開始"
#sudo service apache2 start
#sudo service mysql start


echo "MySQL の初期化"

FLAG=`mysql -uroot -e "select user from mysql.user where user='procon'"`
#echo $FLAG
if [[ -n "$FLAG"  ]]; then
	echo "user was already created"
else
	echo "create user "
	mysql -uroot -e "create user 'procon'@'localhost' identified by 'procon';" && echo "Comp" || echo "faild Create User"
fi

FLAG=`mysql -uroot -e "show databases like 'submit'"`
if [[ -n $FLAG ]]; then
	echo "database was already created"
else
	mysql -uroot -e "create database submit;" && echo "Database create comp" || echo "faild create database"
fi

FLAG=`mysql -uroot -e "show databases like 'questions'"`
if [[ -n $FLAG ]]; then
	echo "database was already created"
else
	mysql -uroot -e "create database questions;" && echo "Database create comp" || echo "faild create database"
fi

DATE=`date +"%y%m%d"`
FLAG=`mysql -uroot -e "show tables from submit like 'submit_$DATE'"`
#echo mysql -uroot -e "show tables from submit like 'submit_$DATE'"
 if [[ -n $FLAG ]]; then
 	echo "table was already created"
 else
 	mysql -uroot -e "create table submit.submit_$DATE(post_time bigint ,team_name varchar(20),problem_num int,language int,status int);"&& echo "table create comp" || echo "faild create table"
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

echo "parse.rbの実行"
ruby parse.rb


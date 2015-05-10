<html>
<head>
<title>judging...</title>
<link rel="stylesheet" type="text/css" href="../stylesheets/screen.css" media="all">
</head>
<body>
<div id="base">
<img src="../images/loading.gif" width = "">
<?php
//check team name (if not alphabet...)
 if (ctype_alpha($_POST['team_name']) == false) {
  	$js = <<<EOD
 PHP Error. Please wirte team name only <font color = "red">Alphabet.</font><a href="javascript:history.back();"> please retry</a>
EOD;
 	echo($js);
 }else{
	//save source files
	 $post_time = time();
	 $fh = fopen("../submit_file/$post_time",'w');
	 fwrite($fh,$_POST['source']);
	 fclose($fh);

	//Connection to DB
	$table_name = "submit_".date("ymd");
	if(!$link = mysql_connect('localhost','procon','procon')){
		die('Connection Error.'.mysql_error());
	}		
	if(!$db_select = mysql_select_db('submit',$link)){
		die('Selection Error.'.mysql_error());
	}

	//Make data insert to DB
	$team_name = $_POST['team_name'];
	$problem_num = $_POST['problem_num'];
	$language = $_POST['language'];
	$status = 1;

	$insert_sql = sprintf("INSERT INTO %s (post_time,team_name,problem_num,language,status) VALUES ('%d','%s','%d','%d','%d')",$table_name,$post_time,$team_name,$problem_num,$language,$status);
	$result_flag = mysql_query($insert_sql);
  	if(!$result_flag) {
  		die('Error. Insert cannot.'.mysql_error());
  	}

  	exec('bash run.sh &',$op);
  	$log_fh = fopen("../log/".$post_time."_run.log",'w');
  	fwrite($log_fh, $op);
  	fclose($log_fh);
  	echo $op;

}
?>
</div>

</body>
</html>
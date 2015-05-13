<html>
<head>
<title>judging...</title>
<link rel="stylesheet" type="text/css" href="../stylesheets/screen.css" media="all">
</head>
<body>
<div id="base">
now actionning. please wait...
<img src="../images/loading.gif" width = "">
<?php
//check team name (if not alphabet...)
  	$input = 0;
  	$Stocker = 0;
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

 	#exec('bash run.sh &'); 
  	#sleep(10);
  	#passthru('bash run.sh &',$op);
  	$fp = fopen("STOCK", "r");
  	while (true) {
	  	if(flock($fp, LOCK_EX)){
		  	while (!feof($fp)) {
		  			$input = fgets($fp);
		  			#echo "input num is".$input."<br>";
		  			break;
		  		}
		  		$input = (int)$input;
		  		$Stocker =  $input + 1;
		  		echo "<br> In que : ".$Stocker;  
		  		break;		
	  	}
	  	else{
	  		sleep(1);
	  	}
	}
  	fclose($fp);
	$fp = fopen("STOCK", "w+");
	$fp2 = fopen("Time","w+");
 # 	echo $fp;
	while (true) {
	  	if(flock($fp, LOCK_EX)){    //排他的ロック
		    fwrite($fp, $Stocker);
		    break;
		}
		else{
	    	sleep(1);
		}
	}
	while (true) {
	  	if(flock($fp2, LOCK_EX)){    //排他的ロック
		    fwrite($fp2, $post_time);
		    break;
		}
		else{
	    	sleep(1);
		}
	}
 
	fclose($fp);    //ここでロックが解除される。
  	#$log_fh = fopen("../log/".$post_time."_run.log",'w');
  	#fwrite($log_fh, $op);
  	#fclose($log_fh);

}
?>
<br>
after <font color="red">10</font>s, please access <a href="./20150210/result.html">result page </a>
</div>

</body>
</html>
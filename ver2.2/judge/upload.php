<html>
<head>
<title>judging...</title>
<link rel="stylesheet" type="text/css" href="../stylesheets/screen.css" media="all">
</head>
<body>
<div id="base">
<?php
echo "helloworld";
//チームがアルファベット以外の場合は動作を終了させる
 if (ctype_alpha($_POST['team_name']) == false) {
 	$js = <<<EOD
PHP Error. Please wirte team name only <font color = "red">Alphabet.</font><a href="javascript:history.back();"> please retry</a>
EOD;
	echo($js);

 }else{
	echo "helloworld";
	//teamnameの取得
	//echo "team name :" . htmlspecialchars($_POST['team_name']) . "<br />";
	//echo "progrem num :" . $_POST['problem_num']."<br />";
	//echo "source code :" . $_POST['source']; 

	//ソースの保存
	$language = $_POST['language'];
	switch ($language) {
		case 0:
			$file = $_POST['team_name'] . "_" . $_POST['problem_num'];
			$fh = fopen("../submit_file/$file.cpp",'w');
			//echo $file."<br>";
			fwrite($fh,$_POST['source']);
			fclose($fh);
			break;
		case 1:
			$file = $_POST['team_name'] . "_" . $_POST['problem_num'];
			$fh = fopen("../submit_file/$file.cpp",'w');
			//echo $file."<br>";
			fwrite($fh,$_POST['source']);
			fclose($fh);
			break;
		case 2:
			#$file = $_POST['team_name'] . "_" . $_POST['problem_num'];
			$file = $_POST['team_name'] ;
			$fh = fopen("../submit_file/$file.java",'w');
			//echo $file."<br>";
			fwrite($fh,$_POST['source']);
			fclose($fh);
			break;
		case 3:
			$file = $_POST['team_name'] . "_" . $_POST['problem_num'];
			$fh = fopen("../submit_file/$file.rb",'w');
			//echo $file."<br>";
			fwrite($fh,$_POST['source']);
			fclose($fh);
			break;		
		case 4:
			$file = $_POST['team_name'] . "_" . $_POST['problem_num'];
			$fh = fopen("../submit_file/$file.py",'w');
			//echo $file."<br>";
			fwrite($fh,$_POST['source']);
			fclose($fh);
			break;
		case 5:
			$file = $_POST['team_name'] . "_" . $_POST['problem_num'];
			$fh = fopen("../submit_file/$file.py",'w');
			//echo $file."<br>";
			fwrite($fh,$_POST['source']);
			fclose($fh);
			break;
		default:
			echo "error";
			break;
	}
	// $file = $_POST['team_name'] . "_" . $_POST['problem_num'];
	// $fh = fopen("../submit_file/$file.cpp",'w');
	// //echo $file."<br>";
	// fwrite($fh,$_POST['source']);
	// fclose($fh);

	//15/01/26add : Jsonファイルの日付取得
	//$date = date("Ymd");
	//$data = "20150210";
	$date = "20150210";
	ob_start();
	 exec('ls ../problem_list |grep -v html',$op2);
	 print_r($op2);
	for ($i=0; $i < count($op2) ; $i++) { 
		echo $i . "<br>";
		if ($op2[$i] >= $date) {
			$date = $op2[$i];
			echo $date;
			break;
		}
		if($i+1 == count($op2)){
			$flag = 1;
			break;
		}
	}
	ob_end_clean();
	//ファイルが無い場合は、メッセージを表示させた後、強制終了
	if($flag){
		echo("<font color = \"red\" >File error. Please call Admins. </font>");
		exit;
	}

	//JSONの取得 
	$json_file_name = "../problem_list/" . $date ."/". $date . ".json";
	$json = file_get_contents($json_file_name);
	$json = mb_convert_encoding($json, 'UTF8' , 'ASCII,JIS,UTF-8,EUC-JP,SJIS-WIN');
	$obj = json_decode($json,true);
	if ($obj === NULL){
		return ;
	}
	//echo $obj['contest']['question'][1]['numOfSample']."<br>";

	$action_time = $obj['contest']['question'][$_POST['problem_num']-1]['time'];
	$memory = $obj['contest']['question'][$_POST['problem_num']-1]['mem'];
	$input_times = $obj['contest']['question'][$_POST['problem_num']-1]['numOfTestcase'];
	$precision = $obj['contest']['question'][$_POST['problem_num']-1]['precision'];
	echo $action_time . "<br>";
	echo $memory ."<br>";
	echo $input_times ."<br>";
	echo $precision ."<br>";


	 
	//configの作成
	$config =  $_POST['team_name'] . "\n" . $_POST['problem_num'] ."\n".$action_time  ."\n". $memory ."\n". $input_times ."\n". $precision ."\n". $_POST['language'] ;
	$fh2 = fopen('config','w');
	fwrite($fh2,$config);
	fclose($fh2);
	 
	ob_start();
	//$comamnd = "\'ruby judge.rb < config \'";
	exec('/usr/local/rbenv/shims/ruby judge.rb < config',$op);
	//system('/usr/local/src/ruby-2.0.0-p598/ruby judge.rb < config',$op);

	print_r($op);
	$buffer = ob_get_contents();
	$fh_out = fopen("log.txt",'w');
	fwrite($fh_out,$buffer);
	ob_end_clean();
	fclose($fh_out);

	ob_end_clean();
	$refresh = <<<EOD
<meta http-equiv="refresh" content="0;URL=../problem_list/20150210/result.html"
EOD;
	echo($refresh);

 }
?>
</div>

</body>
</html>

<?php
//DBへの接続。要ユーザー作成(create user 'procon'@'procon idetifide by procon')
$link = mysql_connect('localhost','procon','procon');		//学内LANではローカルホストが使えないはず。要確認

$table_name = "submit_".date("ymd");

if (!$link){
	die('Connection Error.'.mysql_error());
}


$db_select = mysql_select_db('submit',$link);
if (!$db_select){
	die('Selection Error.'.mysql_error());
}

$post_time = time();
$team_name = "\"testA\"";
$problem_num = 1;
$language = 0;
$status = 1;
/* statusコードの解釈
1:提出
2:コンパイル済み
3:実行済み
4:比較済み
5:結果表示済み
*/

  $insert_sql = sprintf("INSERT INTO %s (post_time,team_name,problem_num,language,status) VALUES (%d,%s,%d,%d,%d)",$table_name,$post_time,$team_name,$problem_num,$language,$status);
  echo $insert_sql;
  $result_flag = mysql_query($insert_sql);
  if(!$result_flag) {
  	die('Error. Insert cannot.'.mysql_error());
  }

$result = mysql_query('SELECT * From '.$table_name);
if(!$result){
	die('GetData fail.'.mysql_error());
}
$row = mysql_fetch_assoc($result);

/*$sql = sprintf('DELETE FROM %s WHERE post_time = %d ',$table_name,$row['post_time']);
if(!mysql_query($sql)){
	die("Delete Error .".mysql_error());
}
*/
while ($row = mysql_fetch_assoc($result)){
	print ('<p>');
	print ('uptime='.$row['post_time']);
	print (',team_name='.$row['team_name']);
	print (',problem_num='.$row['problem_num']);
	print (',language='.$row['language']);
	print ('status='.$row['status']);
	print ('</p>');
}

echo ("<br>-------<br>");
print($result);
echo ("<br>--------<br>");


print_r(mysql_fetch_assoc($result));
if (mysql_close($link)){
	print('Disconnection finished <br>');
}
?>
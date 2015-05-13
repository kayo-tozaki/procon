<?php

$link = mysql_connect('localhost','testuser','testuser');

if (!$link) {
	due('接続失敗'.mysql_error());
}

print('接続成功 <br>');

$db_selected = mysql_select_db('uriage',$link);
if (!$db_selected){
	die('選択失敗'.mysql_error());
}

print('<p>uriageデータベースの選択が出来ました。</p>');

//mysql_set_charset('utf8');

$result = mysql_query('SELECT id,name From shouhin');
if (!$result){
	die('SELECTクエリーが失敗'.mysql_error());
}

while ($row = mysql_fetch_assoc($result)) {
	print('<p>');
	print('id='.$row['id']);
	print(',name='.$row['name']);
	print('</p>');
}

print("データの削除を行います。<br>");
$sql = "DELETE FROM shouhin WHERE id = 4";
$result_flag = mysql_query($sql);

if (!$result_flag) {
	die('DELETEクエリが失敗しました'.mysql_error());
}

print("データの追加を行います。<br>");

$sql = "INSERT INTO shouhin (id,name) VALUES (4,'プリンター')";
$result_flag = mysql_query($sql);

if (!$result_flag) {
	die('INSERTクエリがお亡くなりに '.mysql_error());
}

print("追加後のデータの表示 <br>");

$result = mysql_query('SELECT id,name From shouhin');
if (!$result){
	die('SELECTクエリーが失敗'.mysql_error());
}

while ($row = mysql_fetch_assoc($result)) {
	print('<p>');
	print('id='.$row['id']);
	print(',name='.$row['name']);
	print('</p>');
}


$close_flag = mysql_close($link);

if ($close_flag){
	print('切断完了 <br>');
}


?>

##add git test
##add github test

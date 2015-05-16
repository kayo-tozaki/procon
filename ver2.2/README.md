#ver2.2
ジャッジシステム本体です。システムを動かす上で必要なファイルが入っています。

#各ディレクトリの役割
##`compare_file/`
比較するための input/output ファイルを格納してある。  
実施予定のサンプル input/output を用意すること。

*過去のサンプルインプットを入れておくと、正しく機能しません。*

##`images/`
問題HTML等で使用する画像データを格納。

##`javascrips/`
HTMLで使用するJavascriptが格納されている。

##`judge/`
提出プログラム・実行/結果判断プログラム・結果表示プログラムが格納されている。
詳細は、`judge/README.md`を参照のこと。

##`log/`
各種ログを保存してある。  
タイトル名は、*提出時刻_* ＋　以下のどれかである。
 * Aerror : Action Error (提出されたプログラムの実行時エラー)
 * CreateResult.log : (結果ページ生成プログラム(`judge/create_result/create_result_test.rb`)のログ)
 * CRrunerror.log : CreateResult Run Error (結果ページ生成プログラムのエラーログ)
 * judge.log : (ジャッジプログラム(`judge/judge_test.rb`)の実行ログ)
 * result : (提出されたプログラムの実行結果)
 * runError.log : (ジャッジプログラム(`judge/judge_test.rb`)の実行時エラーログ)

また、別途で、
 * crontab.log : (cronta.sh の実行エラーログ)

が生成される。

##`problem_list/`
問題ページHTMLが格納されている。  
詳細は、`problem_list/README.md`を参照されたし。

##`stylesheets`
問題ページを表示する上で必要な ccs が格納されている。

##`submit_file`
提出されたプログラムを格納。  
提出時間でファイルを保存されており、DBに登録されている。

##`config.rb`
sassを使う上で出てきたファイル。（※WEBは担当が違うため、わからない。）

###crontab.rb
crontab に登録するファイル。  

`judge/judge_test.rb`が実行される際、TLEでのプロセスキルに伴って、  
`judge/inotify.sh`も実行が `Terminated` される。  
この`judge/inotify.sh`の実行を再開するために、このファイルをcrontabに登録して使用する。

crontab には、以下の設定を記述。  

```
$ crontab -e

#↓追加
* * * * * for i in `seq 0 10 59`;do (sleep ${i}; /bin/bash /var/www/html/ver2.2/crontab.sh > /var/www/html/ver2.2/log/crontab.log) & done; > /dev/null 2>&1
```
これで、一定時間後、自動的にinotify.shを再開するようになる。  
更に、起動時に勝手にスタートする。

##`index.html`
プログラミングコンテストのトップページ。HTMLでアクセスする際はここがトップとなる。

##`parse.rb`
JSONファイルから、各問題のConfigファイルを、`./judge/`に作成する。

実行前に、ソース内の日付設定をする必要があり。

##`README.md`
本ファイル。各ファイルの簡単な説明をしている。

##`SourceHanSansJP-Light.woff`
フォントファイル。（※担当外のため、不明）

##startup.sh
DB関連の初期化と生成を行う。

初期生成後、`judge/result_notify.sh`を起動し、結果生成プログラムの起動待機を行う。

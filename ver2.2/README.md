各プログラムで必要なやつ
##startup.sh
DB関連の初期化と生成を行います。

最後に、parse.rbへとぶん投げます。

##parse.rb
JSONファイルから、各問題のConfigファイルを、`./judge/`に作成します。

実行時に、日付の設定をする必要があります。

##crontab.sh
crontab に以下の設定を記述。

```
* * * * * for i in `seq 0 10 59`;do (sleep ${i}; /bin/bash /var/www/html/ver2.2/crontab.sh > /var/www/html/ver2.2/log/crontab.log) & done; > /dev/null 2>&1
```

これで、一定時間後、自動的にinotify.shを再開するようになる。


#mysql table登録
##日付毎にテーブルの作成
```
create table submit_`date +"%y%m%d"` (post_time bigint ,team_name varchar(20),problem_num int,language int,status int)
```

##単純テーブルの作成

```
create table submit_test(post_time bigint ,team_name varchar(20),problem_num int,language int,status int)
```

###テーブルの要素

| 変数名      | 変数の種類  |
| :--         | :--         |
| post_time   | bigint      |
| team_name   | varchar(20) |
| problem_num | int [^1]    |
| language    | int         |
| status      | int         |

[^1]: 問題番号と数字はA−Z / 1-26 で対応

####language 対応表
| 番号 | 言語    |
| :--  | :--     |
| 0    | C       |
| 1    | C++     |
| 2    | Java    |
| 3    | Ruby    |
| 4    | Python2 |
| 5    | Python3 |

####status 対応表
| 番号 | 状態                              |
| :--  | :--                               |
| 1    | 提出完了                          |
| 2    | コンパイル済み                    |
| 21   | コンパイル失敗(コンパイルエラー） |
| 22   | コンパイル失敗（コンパイルのTLE） |
| 23   | コンパル（ warnig occur)          |
| 3    | 実行済み                          |
| 31   | 実行エラー(Runtime error)         |
| 32   | 実行エラー(TLE)                   |
| 4    | 比較済み  (AC)                    |
| 41   | 比較済み  (WA)                    |
| 5    | 結果表示済み                      |



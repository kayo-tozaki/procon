# Programing Contest tool ver2.2

this project backup has GitHub and GitLab

# お断り
セキュリティの対策よりも、とりあえず動くことを最優先しているので、  
<font color="red">クローズドでの運用をおすすめします。</font>

# 各ファイル・ディレクトリの役割
各ディレクトリ内の詳細な解説は、そのディレクトリにある、`README.md`を参考されたし。[^1]

## `database.md`
本プログラムで使用されるデータベース(MySQL)にセットしてあるカラムや、  
ステータスコードの対応表が記述してある。

## `index.html`
Apache HTTP Server の__It works!__ のファイル。

## `make_problem/`
問題生成プログラム。作成者は別途にいるが、便宜上同じレポジトリに保存  
詳細な解説は、内部にある、`document/index.html`を参考されたし。

## `original_file/`
旧ジャッジサーバで使用したファイル群。

## `README.md`
このファイル。

## `sample_code/`
各種サンプルコード。

## `ver2.2/`
本プログラム。

## `ver2.2.sublime-project`
Sublime Text 3 で使用するプロジェクトファイル。  
特に凝った設定はないが、

 - `/(ルートディレクトリ)`以下
 - `ver2.2/`以下

のディレクトリを見るように設定が記述してある。

[^1]:`make_problem/`は除く

/** HtmlEditorの宣言ファイル
* @file HtmlEditor.h
* @auther fujihiro_sn
* 
*/


#ifndef HTMLEDITOR_H
#define HTMLEDITOR_H

#include <iostream>

/**
* htmlを保持し、それの簡単な編集と出力を行うクラス<br>
* これ単体ではあまり有用とは言えないが、これを継承したクラスのコーディング量を削減する効果がある。
*/
class HtmlEditor {
public:
	/**
	* コンストラクタ
	* 初期化以外は特に何もしない
	*/
	HtmlEditor();

	/**
	* デストラクタ
	* 何もしない
	*/
	~HtmlEditor();


	/** 外部のファイルをhtmlとして読み込む関数
	* 成功したかどうかは<fail>を呼び出して調べる
	* @param[in] ifname ファイル名
	* @return void
	*/
	void import(const std::string& ifname);	//import html from a file

	/** 引数の文字列をhtmlとして読み込む関数
	* @param[in] htmlStre htmlとする文字列
	* @return void
	*/
	void set(const std::string& htmlStr);	//set html from a string

	/** 現在のhtmlを文字列として返す関数
	* @param なし
	* @return htmlの文字列
	*/
	std::string get();

	/** ファイルにhtmlとして書き込む関数 (拡張子はこちらでは指定しないので.htmlとは限らない)
	* 成功したかどうかは<fail>を呼び出して調べる
	* @param[in] ofname 出力ファイル名
	* @return void
	*/
	void write(const std::string& ofname);	//write html to a file

	/** すべての対象文字列を指定文字列に変換する関数 (strReplacerクラスを使用)
	* @param[in] from 対象文字列
	* @param[in] to 指定文字列
	* @return void
	*/
	void replace(const std::string& from, const std::string& to);	//edit html 

	/** 何かしらの動作で失敗したかどうかを返す関数
	* @param なし
	* @return true  直前の作業で失敗
	* @return false 直前の作業で成功
	*/
	bool fail();

private:
	//! 保持するhtml文字列
	std::string html;

	//! 直前の作業で成功したかどうかを保持
	bool isfail;

};

#endif //HTMLGENERAOTR_H
#ifndef STR_REPLACER_H
#define STR_REPLACER_H

#include <iostream>

/** 
* すべての対象文字列を指定文字列に変換するクラス
*/
class StrReplacer {
public:

	/**
	* コンストラクタ
	* 初期化以外は特に何もしない
	*/
	StrReplacer();

	/**
	* 変換文字列を指定するコンストラクタ
	* @param str 変換対象とされる文字列
	*/
	StrReplacer(const std::string& str);

	/**
	* デストラクタ
	* 何もしない
	*/
	~StrReplacer();

	/**
	* 変換文字列を指定する関数
	* @param str 変換対象とされる文字列
	*/
	void setStr(const std::string& str);

	/**
	* 編集した文字列を返す関数
	* @param なし
	* @return 編集した文字列 
	*/
	std::string getStr();

	/**
	* すべての対象文字列を指定文字列に変換するクラス
	* @param[in] from 対象文字列
	* @param[in] to 指定文字列
	* @return int 変換した個数
	*/
	int replace(const std::string& from, const std::string& to);

private:
	std::string replaceStr;

};

#endif // STR_REPLACE_H

#ifndef JSONVALIDATOR_H
#define JSONVALIDATOR_H

#include <iostream>
#include "picojson.h"


/**
* jsonのバリデーションを行うクラス
*/
class JsonValidator {
public:

	/**
	* json schemaのパスを設定するコンストラクタ 
	* @param str schemaのパス
	*/
	JsonValidator(std::string str);

	/**
	* デストラクタ
	* 何もしない
	*/
	~JsonValidator();

	/**
	* json schemaのパスを設定する(変更)
	* @param str schemaのパス
	*/
	void setSchema(const std::string& filePath);

	/**
	* エラー情報を返す<br>
	* 文字列が空ならエラーは発生していない
	* @param なし
	* @return string エラー文字列
	*/
	std::string getError();

	/**
	* エラーリストを返す
	* @param なし
	* @return string エラーリスト
	*/
	std::string getErrorList();

	/**
	* バリデーションを行う
	* @param filepath バリデーション対象のパス
	* @return void
	*/
	void validation(const std::string& filePath);

private:
	JsonValidator();
	std::string checkSyntax(std::ifstream& ifs);
	std::string genErrList(const std::string& filePath);

	std::string m_schemaPath;
	std::string m_errStr;	//エラーがあったらそれに関する文字列が入る(空ならエラーは起きていない)
	std::string m_errList;	//発生したエラーのリストが入る

	static const std::string c_command;	//バリデータのコマンド.オプションとかファイルは指定していないただのコマンド
};

#endif
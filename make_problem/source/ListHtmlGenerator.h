#ifndef LIST_HTMLGENERATOR_H
#define LIST_HTMLGENERATOR_H

#include "HtmlEditor.h"

/**
* 問題一覧ページを作成するクラス。<br>
* HtmlEditorを継承。
*/
class ListHtmlGenerator :
	public HtmlEditor {
public:
	/**
	* コンストラクタ<br>
	* HtmlEditorのhtmlに"listTemplate.html"を読み込ませる。<br>
	* 読み込ませるパスは、"./resources/listTemplate.html"である。
	*/
	ListHtmlGenerator();

	/**
	* デストラクタ<br>
	* テンプレートのテーブル部分を置換した後、
	* HtmlEditorのwriteメソッドを用いてhtmlの出力を行う。<br>
	*/
	~ListHtmlGenerator();

	/**
	* コンテストタイトルを設定する関数
	* @param[in] contestTitle コンテストタイトル
	* @return void
	*/
	void setTitle(const std::string& contestTitle);

	/**
	* コンテストの日付を設定する関数
	* @param[in] dateStr コンテストの日付
	* @return void
	*/
	void setDate(const std::string& dateStr);

	/**
	* 問題情報を設定する関数
	* @param[in] title		タイトル
	* @param[in] No			番号
	* @param[in] timeLimit	制限時間
	* @param[in] memLimit	制限メモリ
	* @return void
	*/
	void addProblemData(const std::string& title, int No, int timeLimit, int memLimit);

private:
	std::string contestTitle;
	std::string date;			//ex. 20141227	
	std::string tables;			//tables of problem data
	std::string tableTemplate;	//template of table
	int numOfProblem;			//number of problem(=table)
};

#endif //LIST_HTMLGENERATOR_H
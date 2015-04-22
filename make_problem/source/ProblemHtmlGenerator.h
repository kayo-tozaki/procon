#ifndef PROBLEM_HTMLGENERATOR_H
#define PROBLEM_HTMLGENERATOR_H

#include "HtmlEditor.h"

/**
* 問題ページを作成するクラス。<br>
* HtmlEditorを継承。
*/
class ProblemHtmlGenerator :
	public HtmlEditor {
public:

	/**
	* コンストラクタ<br>
	* HtmlEditorのhtmlに"problemTemplate.html"を読み込ませる。<br>
	* 読み込ませるパスは、"./resources/problemTemplate.html"である。
	*/
	ProblemHtmlGenerator();
	
	/**
	* デストラクタ<br>
	* HtmlEditorのwriteメソッドを用いてhtmlの出力を行う。<br>
	*/
	~ProblemHtmlGenerator();

	/**
	* 問題情報を設定する関数
	* @param[in] title		タイトル
	* @param[in] timeLimit	制限時間
	* @param[in] memLimit	制限メモリ
	* @return void
	*/
	void setProblemInfo(const std::string& title, int timeLimit, int memLimit);

	/**
	* 問題情報を設定する関数
	* @param[in] dateStr	日付の文字列
	* @return void
	*/
	void setDate(const std::string& dateStr);

	/**
	* 問題情報を設定する関数
	* @param[in] numOfProblem	問題番号
	* @return void
	*/
	void setProblemNum(int problemNo, int numOfProblem);
	
	/**
	* 問題情報を設定する関数
	* @param[in] str 問題文
	* @return void
	*/
	void setStatement(const std::string& str);

	/**
	* 問題情報を設定する関数
	* @param[in] str 入力の説明文
	* @return void
	*/
	void setInput(const std::string& str);

	/**
	* 問題情報を設定する関数
	* @param[in] str 構成の説明文
	* @return void
	*/
	void setConstraints(const std::string& str);

	/**
	* 問題情報を設定する関数
	* @param[in] str 出力の説明文
	* @return void
	*/
	void setOutput(const std::string& str);

	/**
	* 問題情報を設定する関数
	* @param[in] str サンプル部分
	* @return void
	*/
	void setSample(const std::string& str);

private:
	std::string problemTitle;
	std::string date;			//ex. 20141227	
	int problemNo;

};

#endif //PROBLEM_HTMLGENERATOR_H
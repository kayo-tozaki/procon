/**
* @file source.cpp
*
* @mainpage
* 本プログラムは、リソースと指定されたJSONファイルを用いてwebサイト(の問題表示部分)を出力するプログラムである。
*
* @section 処理の概要
* 本プログラムは、コマンドライン引数として支持されたJSONファイルの内容をもとにhtmlを作成するために作成された。<br>
* 入力されるJSONの文法が正しいかをJsonValidatorを用いて検証するので、文法に誤りがあった場合はそこで処理を終了する。<br>
* また、JsonValidatorはJAVAで書かれているプログラムを使用しているため、本プログラムを実行するにはJAVAの実行環境が必須である。<br>
* そして、内容の検証が済んだJsonを"picojson"というライブラリを用いてパースしながら必要なデータを抽出し、htmlを作成していく。<br>
* 作成するhtmlのひな形はテンプレートとしてresouresフォルダに格納されており、
*
* - problemTemplate.html
* - listTemplate.html
* - tableTemplate.html
*
* の3つがこれに当たる。<br>
*
* @section コンパイル方法
* 本プログラムのコンパイルは、Visual Studioを用いる場合は通常通りのビルドで可能である。<br>
* g++でコンパイルする場合は、"-std=gnu++11"オプションを指定し、すべてのcppファイルを指定する。<br>
* また、コンパイル環境はwindows、Linuxでの確認を行った(Macは不明)。
*
* @section 実行にあたって
* 本プログラムでは、入力するJsonファイル名をプログラム起動時のコマンドライン引数として読み込ませる。<br>
* そして、サンプル入出力の内容が格納されたファイルをプログラムと同一フォルダに配置する。<br>
* また、起動の際にresourceフォルダ内に以下のファイルが揃っていなければ正常に動作しない。<br>
* 
* - json-schema-validator-2.2.6-lib.jar
* - problemTemplate.html
* - listTemplate.html
* - tableTemplate.html
* - schema.json
*
* @section 作成されるファイル
* プログラムが正常に実行されると、プログラムと同一階層に"problem{日付}.html"が作成される。<br>
* そして、"{日付}"フォルダが作成され、その中に各問題のhtmlが配置される。
* 
* @section jsonファイルについて
* jsonファイルの文法については、付属の"JSON構文.txt"及び"schema.json"を参照すること。
*
* @auther fujihiro_sn
*/

#include <iostream>
#include <map>
#include <fstream>
#include <sstream>
#include <iomanip>
#include "picojson.h"
#include "JsonValidator.h"
#include "StrReplacer.h"
#include "ListHtmlGenerator.h"
#include "ProblemHtmlGenerator.h"

void genListPage(picojson::object contestObj);
void genProblemPage(picojson::object contestObj);
std::string genSection(picojson::array section, std::string id, std::string class_);
std::string genSamples(picojson::array samples);



int main(int argc, char *argv[]) {

	using std::cout;
	using std::cerr;
	using std::cin;
	using std::endl;

	if (argc != 2) {
		cerr << "invalid argument" << endl;
		cerr << "usage : program.exe [contest json]" << endl;
		return 1;
	}
	
	JsonValidator test("./resources/schema.json");
	
	test.validation(argv[1]);

	std::string err = test.getError();
	if (!err.empty()) {
		cout << test.getError() << endl;
		cout << test.getErrorList() << endl;
		return 2;
	}
	
	std::ifstream ifs(argv[1]);
	picojson::value v;

	if (ifs.fail()) {		//missing file
		cout << "cannot open contest json" << endl;
		return 1;
	}

	ifs >> v;
	std::string perr = picojson::get_last_error();
	if (!perr.empty()) {	//パース失敗
		cout << perr << endl;
		return 1;
	}

	//ここまでで全データの検証が済んでいるので、これ以降データのチェックは基本行わない

	//コンテストデータのメインオブジェクトを取得
	picojson::object contestObj = v.get<picojson::object>()["contest"].get<picojson::object>();

	genListPage(contestObj);
	genProblemPage(contestObj);
	//cout << v.get<picojson::object>()["contest"].get<picojson::object>()["name"].get<std::string>() << endl;
	
	return 0;
}

/**
* 日付文字列を作成する
* @param[in] date 日付情報が格納されたpicojsonオブジェクト
* @return 日付の文字列
*/
std::string genDate(picojson::object date) {
	std::stringstream ssm;
	
	ssm << date["year"].get<double>() << std::setw(2) << std::setfill('0') << date["month"].get<double>() << std::setw(2) << std::setfill('0') << date["day"].get<double>();
	return ssm.str();
}

/**
* 問題一覧ページを作成する
* @param[in] contestObj コンテスト情報が格納されたpicojsonオブジェクト
* @return void
*/
void genListPage(picojson::object contestObj) {

	ListHtmlGenerator listPage;

	listPage.setTitle(contestObj["name"].get<std::string>());
	listPage.setDate(genDate(contestObj["date"].get<picojson::object>()));

	picojson::array questions = contestObj["question"].get<picojson::array>();
	for (size_t i = 0; i < questions.size(); i++) {
		picojson::object question = questions[i].get<picojson::object>();
		std::string title = question["title"].get<std::string>();
		int timeLimit = question["time"].get<double>();
		int memLimit = question["mem"].get<double>();
		listPage.addProblemData(title, i + 1, timeLimit, memLimit);
	}

}

/**
* 問題ページを作成する
* @param[in] contestObj コンテスト情報が格納されたpicojsonオブジェクト
* @return void
*/
void genProblemPage(picojson::object contestObj) {

	std::string date = genDate(contestObj["date"].get<picojson::object>());
	
	system(("mkdir " + date).c_str());	//ディレクトリ作成

	picojson::array questions = contestObj["question"].get<picojson::array>();

	//問題数分ループ
	for (size_t i = 0; i < questions.size(); i++) {
		ProblemHtmlGenerator problemPage;
		picojson::object question = questions[i].get<picojson::object>();

		//必要な情報を取得
		std::string title = question["title"].get<std::string>();
		int timeLimit = question["time"].get<double>();
		int memLimit = question["mem"].get<double>();

		//情報を設定していく
		problemPage.setProblemInfo(title, timeLimit, memLimit);
		problemPage.setDate(date);
		problemPage.setProblemNum(i + 1, questions.size());

		problemPage.setStatement(genSection(question["statement"].get<picojson::array>(), "question", "sentence"));
		problemPage.setInput(genSection(question["input"].get<picojson::array>(), "input", "sample"));
		problemPage.setConstraints(genSection(question["constraints"].get<picojson::array>(), "constraints", "sentence"));
		problemPage.setOutput(genSection(question["output"].get<picojson::array>(), "output", "sample"));

		problemPage.setSample(genSamples(question["sample"].get<picojson::array>()));
	}

}

/**
* 文字列中のhtmlエスケープ文字を変換する
*@param[in] 変換対象文字列
*@return 変換後文字列
*/
std::string toUsableHtmlStr(std::string str) {

	static std::string from = "<>&";
	static std::vector<std::string> to = { "&lt;", "&gt;", "&amp;" };
	static std::map<char, std::string> convTable;
	if (convTable.empty()) {
		for (size_t i = 0; i < from.size(); i++) {
			convTable[from[i]] = to[i];
		}
	}

	std::string::size_type pos = 0;
	while ((pos = str.find_first_of(from, pos)) != std::string::npos) {
		char c = str[pos];
		str.erase(pos, 1);
		str.insert(pos, convTable[c]);
		pos += convTable[c].size();
	}
	return str;
}

/**
* ソースコードの拡張子とprismの言語指定子との対応付けが記されたファイルを読み込む関数
*@return ソースコードの拡張子をキーとした連想配列を返す
*/
std::map<std::string, std::string> initSyntaxLanguageList() {
	std::ifstream languageListFile("./resources/syntax.csv");
	std::string buffer;

	std::map<std::string, std::string> list;

	if (languageListFile.fail()) {	// cannot open the resource file
		std::cout << "cannot open syntax.csv" << std::endl;
		return list;	// return empty map
	}

	languageListFile >> buffer;

	// ファイルを読み込む
	while (!languageListFile.eof()) {
		// １行読み込む
		languageListFile >> buffer;

		// ファイルから読み込んだ１行の文字列を区切り文字で分けてリストに追加する
		std::istringstream streambuffer(buffer);// 文字列ストリーム
		std::string ext;						// 1セル目にある拡張子
		std::string language;					// 2セル目にある言語名
		std::getline(streambuffer, ext, ',');
		std::getline(streambuffer, language, ',');

		list[ext] = language;	// add language correspondence relationship

	}

	return list;
}

/**
* ソースコードブロックを作成する関数
*@param[in] fileame ソースコードファイル
*@return ソースコードを展開したhtml文字列
*/
std::string genCodeBlock(std::string filename) {

	static std::map<std::string, std::string> syntaxLangList = initSyntaxLanguageList();

	std::stringstream ssm;
	std::string extension;
	std::ifstream ifs(filename);	// open the code file

	if (ifs.fail()) {	// the file could not be opened
		std::cout << "cannot open " << filename << std::endl;
		return std::string();
	}

	// get extension
	std::string::size_type pos;
	if ((pos = filename.find_last_of(".")) != std::string::npos) {
		extension = filename.substr(pos+1);
	}

	// check the extension 
	if (!syntaxLangList.count(extension)) { // if extension does not exit in syntax list
		ssm << "<div class=\"source\"><pre><code class=\"language-clike\">";	// set default(c-like)
	} else {								// if exist in list
		ssm << "<div class=\"source\"><pre><code class=\"language-" << syntaxLangList[extension] << "\">";	// set language's syntax
	}

	// load a source code from the file stream
	std::istreambuf_iterator<char> it(ifs);
	std::istreambuf_iterator<char> ilast;
	std::string iStr(it, ilast);

	// import the file contents to html using "pre" and "code" tag
	ssm << toUsableHtmlStr(iStr) << "</code></pre></div>";

	return ssm.str();
}


/**
* statementやinputなどの節を作成する
* @param[in] section セクション部分が格納されたpicojson配列
* @param[in] id "input"か"output"か指定(htmlの見た目制御用)(現在は使用していない)
* @param[in] class_ "sentence"か"sample"かを指定(htmlの見た目制御用)
* @return 節のhtml文字列
*/
std::string genSection(picojson::array section, std::string id, std::string class_) {
	std::stringstream ssm;

	// process all array's emlement 
	for (auto j = section.begin(); j != section.end(); j++) {

		if (j->is<std::string>()) {		// sentense

			ssm << "\t\t<p class=\"sentence\">" << std::endl << "\t\t\t" << j->get<std::string>() << std::endl << "\t\t</p>" << std::endl;

		} else if (j->is<picojson::array>()) {		// array

			std::stringstream sample;
			for (auto k = j->get<picojson::array>().begin(); k != j->get<picojson::array>().end(); k++) {
				sample << k->get<std::string>() << "<br>";
			}

			ssm << "\t\t<div class=\"" << class_ << "\">" << std::endl;
			ssm << sample.str() << "</div>" << std::endl;

		} else if (j->is<picojson::object>()) {	// Image or Code
			picojson::object& obj = j->get<picojson::object>();
			bool flag = true;
			if (obj["image"].is<std::string>()) {		// if the object is image 
				std::string imgName = obj["image"].get<std::string>();
				ssm << "\t\t<div class=\"image\"><img src=\"./" << imgName << "\"></div>" << std::endl;
				flag = false;
			}

			if (obj["code"].is<std::string>()) {	// if the object is code
				std::string filename = obj["code"].get<std::string>();
				ssm << genCodeBlock(filename) << std::endl;
				flag = false;
			} 

			if (flag) {
				picojson::object::iterator unknown = obj.begin();
				std::cout << unknown->first << " is a unknown property" << std::endl;
			}
		}

	}
	return ssm.str();
}

/**
* サンプル部分を作成する関数
* @param[in] samples サンプル部分が格納されたpicojsonオブジェクト
* @return サンプル部分のhtml文字列
*/
std::string genSamples(picojson::array samples) {
	int sCounter = 1;	//サンプルの個数

	std::stringstream ssm;
	for (auto j = samples.begin(); j != samples.end(); j++, sCounter++) {

		picojson::object& sampleObj = j->get<picojson::object>();

		std::ifstream iifs(sampleObj["sampleIn"].get<std::string>());
		std::ifstream iofs(sampleObj["sampleOut"].get<std::string>());

		// ファイルが開けなかった場合*2
		if (iifs.fail()) {
			std::cerr << std::string("cannot open " + sampleObj["sampleIn"].get<std::string>()) << std::endl;
			exit(2);
		}
		if (iofs.fail()) {
			std::cerr << std::string("cannot open " + sampleObj["sampleOut"].get<std::string>()) << std::endl;
			exit(2);
		}
		// 2つのイテレータに入出力それぞれのファイル内容を読み込ませる
		std::istreambuf_iterator<char> iIt(iifs), oIt(iofs);
		std::istreambuf_iterator<char> ilast, olast;
		std::string iStr(iIt, ilast), oStr(oIt, olast);

		// 読み込んだサンプル内容をhtmlとして整形していく
		// sample input
		ssm << "\t\t<h4>Sample Input " << sCounter << "</h4>" << std::endl;
		ssm << "\t\t<pre class=\"sample\">" << std::endl;
		ssm << iStr << "</pre>" << std::endl;
		// sample output
		ssm << "\t\t<h4>Sample Output " << sCounter << "</h4>" << std::endl;
		ssm << "\t\t<pre class=\"sample\">" << std::endl;
		ssm << oStr << "</pre>" << std::endl;

		// 画像が定義されていたら
		if (sampleObj["image"].is<std::string>()) {
			std::string fileName = sampleObj["image"].get<std::string>();
			ssm << "\t\t<div class=\"image\"><img src=\"./" << fileName << "\"></div>" << std::endl;
		}

		//説明文が定義されていたら
		if (sampleObj["string"].is<std::string>()) {
			ssm << "\t\t<p class=\"sentence\">" << std::endl << "\t\t\t" << sampleObj["string"].get<std::string>() << std::endl << "\t\t</p>" << std::endl;
		}


	}
	return ssm.str();
}


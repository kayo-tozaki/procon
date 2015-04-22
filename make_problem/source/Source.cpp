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
* statementやinputなどの節を作成する
* @param[in] section セクション部分が格納されたpicojson配列
* @param[in] id "input"か"output"か指定(htmlの見た目制御用)(現在は使用していない)
* @param[in] class_ "sentence"か"sample"かを指定(htmlの見た目制御用)
* @return 節のhtml文字列
*/
std::string genSection(picojson::array section, std::string id, std::string class_) {
	std::stringstream ssm;

	for (auto j = section.begin(); j != section.end(); j++) {

		if (j->is<std::string>()) {		//sentense

			ssm << "\t\t<p class=\"sentence\">" << std::endl << "\t\t\t" << j->get<std::string>() << std::endl << "\t\t</p>" << std::endl;

		} else if (j->is<picojson::array>()) {		//array

			std::stringstream sample;
			for (auto k = j->get<picojson::array>().begin(); k != j->get<picojson::array>().end(); k++) {
				sample << k->get<std::string>() << "<br>";
			}

			ssm << "\t\t<div class=\"" << class_ << "\">" << std::endl;
			ssm << sample.str() << "</div>" << std::endl;

		} else if (j->is<picojson::object>()) {	//Image
			picojson::object& img = j->get<picojson::object>();
			if (img["image"].is<std::string>()) {
				std::string imgName = img["image"].get<std::string>();
				ssm << "\t\t<div class=\"image\"><img src=\"./" << imgName << "\"></div>" << std::endl;
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


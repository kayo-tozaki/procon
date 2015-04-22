#include "ProblemHtmlGenerator.h"

#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib>
#include "StrReplacer.h"

std::string genSlect(int numOfProblem, int selectedNum);


ProblemHtmlGenerator::ProblemHtmlGenerator() : problemTitle(), date(), problemNo(0) {
	std::string fpath = "./resources/problemTemplate.html";

	//set html with base class's constructor
	import(fpath);

	//check
	if (this->fail()) {
		std::cerr << "cannot open " << fpath << std::endl;
		exit(-1);
	}

}


ProblemHtmlGenerator::~ProblemHtmlGenerator() {
	std::stringstream ssm;
	ssm << problemNo;
	write(date + "/problem" + ssm.str() + ".html");
}

void ProblemHtmlGenerator::setProblemInfo(const std::string& title, int timeLimit, int memLimit) {
	problemTitle = title;
	replace("_*_*TITLE*_*_", "\t\t\t" + title);

	std::stringstream ssm;
	ssm << "\t\t\tTime Limit : " << timeLimit << " sec, Memory Limit : " << memLimit << " KB";

	replace("_*_*LIMIT*_*_", ssm.str());
}

void ProblemHtmlGenerator::setDate(const std::string& dateStr) {

	date = dateStr;

	std::string mondai = "\xE5\x95\x8F\xE9\xA1\x8C";	//問題 ("mondai" at utf-8)

	//replace "_*_*Problem*_*_" with "<a href="./problem{dateStr}.html">問題</a>"
	replace("_*_*PROBLEM*_*_", "\t\t\t\t<a href=\"../problem" + dateStr + ".html\">" + mondai + "</a>");


}

void ProblemHtmlGenerator::setProblemNum(int problemNo, int numOfProblem) {
	ProblemHtmlGenerator::problemNo = problemNo;
	replace("_*_*SELECT*_*_", genSlect(numOfProblem, problemNo));
}

void ProblemHtmlGenerator::setStatement(const std::string& str) {
	replace("_*_*STATEMENT*_*_", str);
}

void ProblemHtmlGenerator::setInput(const std::string& str) {
	replace("_*_*INPUT*_*_", str);
}

void ProblemHtmlGenerator::setConstraints(const std::string& str) {
	replace("_*_*CONSTRAINTS*_*_", str);
}

void ProblemHtmlGenerator::setOutput(const std::string& str) {
	replace("_*_*OUTPUT*_*_", str);
}

void ProblemHtmlGenerator::setSample(const std::string& str) {
	replace("_*_*SAMPLE*_*_", str);
}


/**
* 問題数分のドロップダウンリストを作成する
* @param[in] numOfProblem  問題数
* @param[in] selectedNum   最初に選ばれている問題(特に指定しないなら0)
* @return ドロップダウンリストの入った文字列
*/
std::string genSlect(int numOfProblem, int selectedNum) {
	std::stringstream ssm;
	ssm << "\t\t\t\t<select name=\"problem_num\" id=\"pn\">" << std::endl;
	for (size_t i = 0; i < numOfProblem; i++) {
		if (i + 1 == selectedNum) {
			ssm << "\t\t\t\t\t<option value = \"" << i + 1 << "\" selected >" << "Problem " << static_cast<char>(i + 'A') << "</option>" << std::endl;
		} else {
			ssm << "\t\t\t\t\t<option value = \"" << i + 1 << "\">" << "Problem " << static_cast<char>(i + 'A') << "</option>" << std::endl;
		}
	}
	ssm << "\t\t\t\t</select>" << std::endl;
	return ssm.str();

}
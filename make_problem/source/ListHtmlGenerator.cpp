#include "ListHtmlGenerator.h"

#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib>
#include "StrReplacer.h"

ListHtmlGenerator::ListHtmlGenerator() : contestTitle(), date(), tables(), numOfProblem(0) {

	std::string fpath = "./resources/listTemplate.html";

	//set html with base classes constructor
	import(fpath);

	//check
	if (this->fail()) {
		std::cerr << "cannot open " << fpath << std::endl;
		exit(-1);
	}


	//set table template

	std::string tablePath = "./resources/tableTemplate.html";
	std::ifstream tableTempFs(tablePath);
	if (tableTempFs.fail()) {
		std::cerr << "cannot open " << tablePath << std::endl;
		exit(-1);
	}
	std::istreambuf_iterator<char> it(tableTempFs);
	std::istreambuf_iterator<char> last;
	tableTemplate = std::string(it, last);
}


ListHtmlGenerator::~ListHtmlGenerator() {
	replace("_*_*TABLE*_*_", tables);

	write("./problem" + date + ".html");

}


void ListHtmlGenerator::setTitle(const std::string& contestTitle){
	replace("_*_*TITLE*_*_", "\t\t\t" + contestTitle);
}


void ListHtmlGenerator::setDate(const std::string& dateStr) {

	date = dateStr;

	std::string kekka = "\xE7\xB5\x90\xE6\x9E\x9C";		//Œ‹‰Ê ("kekka" at utf-8)
	std::string mondai = "\xE5\x95\x8F\xE9\xA1\x8C";	//–â‘è ("mondai" at utf-8)

	//replace "_*_*RESULT*_*_" with "<a href="./{dateStr}/result.html">Œ‹‰Ê</a>"
	replace("_*_*RESULT*_*_", "\t\t\t\t<a href=\"./" + dateStr + "/result.html\">" + kekka + "</a>");

	//replace "_*_*Problem*_*_" with "<a href="./problem{dateStr}.html">–â‘è</a>"
	replace("_*_*PROBLEM*_*_", "\t\t\t\t<a href=\"./problem" + dateStr + ".html\">" + mondai + "</a>");


}

void ListHtmlGenerator::addProblemData(const std::string& title, int No, int timeLimit, int memLimit) {

	StrReplacer table(tableTemplate);

	//for MinGW's bug
	std::stringstream ssmAlpha;
	std::stringstream ssmNo;
	std::stringstream ssmTime;
	std::stringstream ssmMem;

	ssmAlpha << static_cast<char>(No + 64);
	ssmNo << No;
	ssmTime << timeLimit;
	ssmMem << memLimit;
	
	table.replace("_*_*No*_*_", "\t\t\t\t" + ssmAlpha.str());
	table.replace("_*_*LINK*_*_", "\t\t\t\t<a href=\"./" + date + "/problem" + ssmNo.str() + ".html\">");
	table.replace("_*_*TITLE*_*_", "\t\t\t\t" + title);
	table.replace("_*_*TIME*_*_", "\t\t\t\t" + ssmTime.str() + "sec");
	table.replace("_*_*MEMORY*_*_", "\t\t\t\t" + ssmMem.str() + "KB");
	
	tables += table.getStr();
}
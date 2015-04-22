/** HtmlEditorの定義ファイル
* @file
* @auther @fujihiro_sn
*
*/
#include "HtmlEditor.h"
#include "StrReplacer.h"

#include <fstream>
#include <string>

HtmlEditor::HtmlEditor(): html(), isfail(false) {
}


HtmlEditor::~HtmlEditor() {
}

/** 外部のファイルをhtmlとして読み込む
* @fn
* ifnameとして渡されたファイル名のファイル内容をhtmlとして読み込む
*
*
*/
void HtmlEditor::import(const std::string& ifname) {
	std::ifstream ifs(ifname);

	//check
	isfail = ifs.fail();
	if (isfail) {
		return;
	}

	std::istreambuf_iterator<char> it(ifs);
	std::istreambuf_iterator<char> last;
	html = std::string(it, last);

}

void HtmlEditor::set(const std::string& htmlStr) {
	html = htmlStr;
	isfail = false;
}

std::string HtmlEditor::get() {
	return html;
}

void HtmlEditor::write(const std::string& ofname) {
	
	std::ofstream ofs(ofname);

	//check
	isfail = ofs.fail();
	if (isfail) {
		return;
	}

	ofs << html;

}


void HtmlEditor::replace(const std::string& from, const std::string& to) {
	StrReplacer rep(html);
	rep.replace(from, to);
	html = rep.getStr();

	isfail = false;
}

bool HtmlEditor::fail() {
	return isfail;
}


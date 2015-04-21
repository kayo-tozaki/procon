#include "StrReplacer.h"


StrReplacer::StrReplacer(): replaceStr() {

}

StrReplacer::StrReplacer(const std::string& str) : replaceStr(str) {

}

StrReplacer::~StrReplacer() {
}

void StrReplacer::setStr(const std::string& str) {
	replaceStr = str;
}

int StrReplacer::replace(const std::string& from, const std::string& to) {
	int counter = 0;	//何個置換されたか
	size_t index = 0;	//初期位置

	//置換対象のインデックスを今までに見つけた場所以降で検索
	//見つからなければ終了
	while ((index = replaceStr.find(from, index)) != std::string::npos) {

		replaceStr.erase(index, from.size());	//置換元文字列を消して
		replaceStr.insert(index, to);			//置換先文字列を挿入

		++counter;
		index += to.size();		//次に検索するのは置換した文字列の次の文字から

	}

	return counter;
}

std::string StrReplacer::getStr() {
	return replaceStr;
}
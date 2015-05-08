#include "InstanceLoader.h"
#include <iostream>
#include <sstream>
#include <string>

//ただのスプリッタ
std::vector<std::string> split(const std::string &s, char delim) {
	std::vector<std::string> elems;
	std::stringstream ss(s);
	std::string item;
	while (std::getline(ss, item, delim)) {
		if (!item.empty()) {
			elems.push_back(item);
		}
	}
	return elems;
}


InstanceLoader::InstanceLoader() {
}

InstanceLoader::InstanceLoader(picojson::object obj) {

}

InstanceLoader::~InstanceLoader() {
}


template<typename T>
T InstanceLoader::get(std::string uri) {		//与えられたURIから指定された型のインスタンスを取得

	//オブジェクト/配列 の名前/インデックス を取得
	std::string id = uri.substr(1, uri.find_first_of("/", 1) - 1);
	size_t slashIndex = uri.find_first_of("/", 1);

	if (slashIndex == std::string::npos) {
		return T();
	}
	
	std::string nextUri = uri.substr(slashIndex);

	T retval = T();

	//もし空文字列だったら空のオブジェクトを返す
	if (id.empty()) {
		return T();
	}


	//数字しかなければ配列、そうでなければオブジェクト
	if (id.find_first_not_of("0123456789") == std::string::npos) {

		retval = get<T>(nextUri);
	} else {
		
		retval = get<T>(nextUri);
	}


	return retval;

}


//これ以外は呼び出さないように
template std::string InstanceLoader::get(std::string uri);		//文字列型
template int InstanceLoader::get(std::string uri);				//整数型
template double InstanceLoader::get(std::string uri);			//数値型
template bool InstanceLoader::get(std::string uri);				//論理型
template picojson::object InstanceLoader::get(std::string uri);	//オブジェクト型
template picojson::array InstanceLoader::get(std::string uri);	//配列型



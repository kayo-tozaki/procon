#ifndef INSTANCE_LOADER_H
#define INSTANCE_LOADER_H
#include "picojson.h"

class InstanceLoader {
public:

	InstanceLoader(picojson::object obj);	//オブジェクトをセットして起動
	~InstanceLoader();

	template<typename T>
	T get(std::string uri);		//与えられたURIから指定された型のインスタンスを取得
	

private:
	InstanceLoader();	//使わない

	template<typename T>
	T getter(std::string uri, picojson::value);

	picojson::object m_mainObj;	//オブジェクト本体

};




#endif // !INSTANCE_LOADER_H

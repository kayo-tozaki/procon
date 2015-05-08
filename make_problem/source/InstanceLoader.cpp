#include "InstanceLoader.h"
#include <iostream>
#include <sstream>
#include <string>

//�����̃X�v���b�^
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
T InstanceLoader::get(std::string uri) {		//�^����ꂽURI����w�肳�ꂽ�^�̃C���X�^���X���擾

	//�I�u�W�F�N�g/�z�� �̖��O/�C���f�b�N�X ���擾
	std::string id = uri.substr(1, uri.find_first_of("/", 1) - 1);
	size_t slashIndex = uri.find_first_of("/", 1);

	if (slashIndex == std::string::npos) {
		return T();
	}
	
	std::string nextUri = uri.substr(slashIndex);

	T retval = T();

	//�����󕶎��񂾂������̃I�u�W�F�N�g��Ԃ�
	if (id.empty()) {
		return T();
	}


	//���������Ȃ���Δz��A�����łȂ���΃I�u�W�F�N�g
	if (id.find_first_not_of("0123456789") == std::string::npos) {

		retval = get<T>(nextUri);
	} else {
		
		retval = get<T>(nextUri);
	}


	return retval;

}


//����ȊO�͌Ăяo���Ȃ��悤��
template std::string InstanceLoader::get(std::string uri);		//������^
template int InstanceLoader::get(std::string uri);				//�����^
template double InstanceLoader::get(std::string uri);			//���l�^
template bool InstanceLoader::get(std::string uri);				//�_���^
template picojson::object InstanceLoader::get(std::string uri);	//�I�u�W�F�N�g�^
template picojson::array InstanceLoader::get(std::string uri);	//�z��^



#ifndef INSTANCE_LOADER_H
#define INSTANCE_LOADER_H
#include "picojson.h"

class InstanceLoader {
public:

	InstanceLoader(picojson::object obj);	//�I�u�W�F�N�g���Z�b�g���ċN��
	~InstanceLoader();

	template<typename T>
	T get(std::string uri);		//�^����ꂽURI����w�肳�ꂽ�^�̃C���X�^���X���擾
	

private:
	InstanceLoader();	//�g��Ȃ�

	template<typename T>
	T getter(std::string uri, picojson::value);

	picojson::object m_mainObj;	//�I�u�W�F�N�g�{��

};




#endif // !INSTANCE_LOADER_H

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
	int counter = 0;	//���u�����ꂽ��
	size_t index = 0;	//�����ʒu

	//�u���Ώۂ̃C���f�b�N�X�����܂łɌ������ꏊ�ȍ~�Ō���
	//������Ȃ���ΏI��
	while ((index = replaceStr.find(from, index)) != std::string::npos) {

		replaceStr.erase(index, from.size());	//�u�����������������
		replaceStr.insert(index, to);			//�u���敶�����}��

		++counter;
		index += to.size();		//���Ɍ�������̂͒u������������̎��̕�������

	}

	return counter;
}

std::string StrReplacer::getStr() {
	return replaceStr;
}
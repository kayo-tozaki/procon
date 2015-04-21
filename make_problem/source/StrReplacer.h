#ifndef STR_REPLACER_H
#define STR_REPLACER_H

#include <iostream>

/** 
* ���ׂĂ̑Ώە�������w�蕶����ɕϊ�����N���X
*/
class StrReplacer {
public:

	/**
	* �R���X�g���N�^
	* �������ȊO�͓��ɉ������Ȃ�
	*/
	StrReplacer();

	/**
	* �ϊ���������w�肷��R���X�g���N�^
	* @param str �ϊ��ΏۂƂ���镶����
	*/
	StrReplacer(const std::string& str);

	/**
	* �f�X�g���N�^
	* �������Ȃ�
	*/
	~StrReplacer();

	/**
	* �ϊ���������w�肷��֐�
	* @param str �ϊ��ΏۂƂ���镶����
	*/
	void setStr(const std::string& str);

	/**
	* �ҏW�����������Ԃ��֐�
	* @param �Ȃ�
	* @return �ҏW���������� 
	*/
	std::string getStr();

	/**
	* ���ׂĂ̑Ώە�������w�蕶����ɕϊ�����N���X
	* @param[in] from �Ώە�����
	* @param[in] to �w�蕶����
	* @return int �ϊ�������
	*/
	int replace(const std::string& from, const std::string& to);

private:
	std::string replaceStr;

};

#endif // STR_REPLACE_H

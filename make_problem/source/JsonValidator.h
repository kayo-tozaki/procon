#ifndef JSONVALIDATOR_H
#define JSONVALIDATOR_H

#include <iostream>
#include "picojson.h"


/**
* json�̃o���f�[�V�������s���N���X
*/
class JsonValidator {
public:

	/**
	* json schema�̃p�X��ݒ肷��R���X�g���N�^ 
	* @param str schema�̃p�X
	*/
	JsonValidator(std::string str);

	/**
	* �f�X�g���N�^
	* �������Ȃ�
	*/
	~JsonValidator();

	/**
	* json schema�̃p�X��ݒ肷��(�ύX)
	* @param str schema�̃p�X
	*/
	void setSchema(const std::string& filePath);

	/**
	* �G���[����Ԃ�<br>
	* �����񂪋�Ȃ�G���[�͔������Ă��Ȃ�
	* @param �Ȃ�
	* @return string �G���[������
	*/
	std::string getError();

	/**
	* �G���[���X�g��Ԃ�
	* @param �Ȃ�
	* @return string �G���[���X�g
	*/
	std::string getErrorList();

	/**
	* �o���f�[�V�������s��
	* @param filepath �o���f�[�V�����Ώۂ̃p�X
	* @return void
	*/
	void validation(const std::string& filePath);

private:
	JsonValidator();
	std::string checkSyntax(std::ifstream& ifs);
	std::string genErrList(const std::string& filePath);

	std::string m_schemaPath;
	std::string m_errStr;	//�G���[���������炻��Ɋւ��镶���񂪓���(��Ȃ�G���[�͋N���Ă��Ȃ�)
	std::string m_errList;	//���������G���[�̃��X�g������

	static const std::string c_command;	//�o���f�[�^�̃R�}���h.�I�v�V�����Ƃ��t�@�C���͎w�肵�Ă��Ȃ������̃R�}���h
};

#endif
/** HtmlEditor�̐錾�t�@�C��
* @file HtmlEditor.h
* @auther fujihiro_sn
* 
*/


#ifndef HTMLEDITOR_H
#define HTMLEDITOR_H

#include <iostream>

/**
* html��ێ����A����̊ȒP�ȕҏW�Əo�͂��s���N���X<br>
* ����P�̂ł͂��܂�L�p�Ƃ͌����Ȃ����A������p�������N���X�̃R�[�f�B���O�ʂ��팸������ʂ�����B
*/
class HtmlEditor {
public:
	/**
	* �R���X�g���N�^
	* �������ȊO�͓��ɉ������Ȃ�
	*/
	HtmlEditor();

	/**
	* �f�X�g���N�^
	* �������Ȃ�
	*/
	~HtmlEditor();


	/** �O���̃t�@�C����html�Ƃ��ēǂݍ��ފ֐�
	* �����������ǂ�����<fail>���Ăяo���Ē��ׂ�
	* @param[in] ifname �t�@�C����
	* @return void
	*/
	void import(const std::string& ifname);	//import html from a file

	/** �����̕������html�Ƃ��ēǂݍ��ފ֐�
	* @param[in] htmlStre html�Ƃ��镶����
	* @return void
	*/
	void set(const std::string& htmlStr);	//set html from a string

	/** ���݂�html�𕶎���Ƃ��ĕԂ��֐�
	* @param �Ȃ�
	* @return html�̕�����
	*/
	std::string get();

	/** �t�@�C����html�Ƃ��ď������ފ֐� (�g���q�͂�����ł͎w�肵�Ȃ��̂�.html�Ƃ͌���Ȃ�)
	* �����������ǂ�����<fail>���Ăяo���Ē��ׂ�
	* @param[in] ofname �o�̓t�@�C����
	* @return void
	*/
	void write(const std::string& ofname);	//write html to a file

	/** ���ׂĂ̑Ώە�������w�蕶����ɕϊ�����֐� (strReplacer�N���X���g�p)
	* @param[in] from �Ώە�����
	* @param[in] to �w�蕶����
	* @return void
	*/
	void replace(const std::string& from, const std::string& to);	//edit html 

	/** ��������̓���Ŏ��s�������ǂ�����Ԃ��֐�
	* @param �Ȃ�
	* @return true  ���O�̍�ƂŎ��s
	* @return false ���O�̍�ƂŐ���
	*/
	bool fail();

private:
	//! �ێ�����html������
	std::string html;

	//! ���O�̍�ƂŐ����������ǂ�����ێ�
	bool isfail;

};

#endif //HTMLGENERAOTR_H
#ifndef LIST_HTMLGENERATOR_H
#define LIST_HTMLGENERATOR_H

#include "HtmlEditor.h"

/**
* ���ꗗ�y�[�W���쐬����N���X�B<br>
* HtmlEditor���p���B
*/
class ListHtmlGenerator :
	public HtmlEditor {
public:
	/**
	* �R���X�g���N�^<br>
	* HtmlEditor��html��"listTemplate.html"��ǂݍ��܂���B<br>
	* �ǂݍ��܂���p�X�́A"./resources/listTemplate.html"�ł���B
	*/
	ListHtmlGenerator();

	/**
	* �f�X�g���N�^<br>
	* �e���v���[�g�̃e�[�u��������u��������A
	* HtmlEditor��write���\�b�h��p����html�̏o�͂��s���B<br>
	*/
	~ListHtmlGenerator();

	/**
	* �R���e�X�g�^�C�g����ݒ肷��֐�
	* @param[in] contestTitle �R���e�X�g�^�C�g��
	* @return void
	*/
	void setTitle(const std::string& contestTitle);

	/**
	* �R���e�X�g�̓��t��ݒ肷��֐�
	* @param[in] dateStr �R���e�X�g�̓��t
	* @return void
	*/
	void setDate(const std::string& dateStr);

	/**
	* ������ݒ肷��֐�
	* @param[in] title		�^�C�g��
	* @param[in] No			�ԍ�
	* @param[in] timeLimit	��������
	* @param[in] memLimit	����������
	* @return void
	*/
	void addProblemData(const std::string& title, int No, int timeLimit, int memLimit);

private:
	std::string contestTitle;
	std::string date;			//ex. 20141227	
	std::string tables;			//tables of problem data
	std::string tableTemplate;	//template of table
	int numOfProblem;			//number of problem(=table)
};

#endif //LIST_HTMLGENERATOR_H
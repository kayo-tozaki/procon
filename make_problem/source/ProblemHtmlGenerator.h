#ifndef PROBLEM_HTMLGENERATOR_H
#define PROBLEM_HTMLGENERATOR_H

#include "HtmlEditor.h"

/**
* ���y�[�W���쐬����N���X�B<br>
* HtmlEditor���p���B
*/
class ProblemHtmlGenerator :
	public HtmlEditor {
public:

	/**
	* �R���X�g���N�^<br>
	* HtmlEditor��html��"problemTemplate.html"��ǂݍ��܂���B<br>
	* �ǂݍ��܂���p�X�́A"./resources/problemTemplate.html"�ł���B
	*/
	ProblemHtmlGenerator();
	
	/**
	* �f�X�g���N�^<br>
	* HtmlEditor��write���\�b�h��p����html�̏o�͂��s���B<br>
	*/
	~ProblemHtmlGenerator();

	/**
	* ������ݒ肷��֐�
	* @param[in] title		�^�C�g��
	* @param[in] timeLimit	��������
	* @param[in] memLimit	����������
	* @return void
	*/
	void setProblemInfo(const std::string& title, int timeLimit, int memLimit);

	/**
	* ������ݒ肷��֐�
	* @param[in] dateStr	���t�̕�����
	* @return void
	*/
	void setDate(const std::string& dateStr);

	/**
	* ������ݒ肷��֐�
	* @param[in] numOfProblem	���ԍ�
	* @return void
	*/
	void setProblemNum(int problemNo, int numOfProblem);
	
	/**
	* ������ݒ肷��֐�
	* @param[in] str ��蕶
	* @return void
	*/
	void setStatement(const std::string& str);

	/**
	* ������ݒ肷��֐�
	* @param[in] str ���͂̐�����
	* @return void
	*/
	void setInput(const std::string& str);

	/**
	* ������ݒ肷��֐�
	* @param[in] str �\���̐�����
	* @return void
	*/
	void setConstraints(const std::string& str);

	/**
	* ������ݒ肷��֐�
	* @param[in] str �o�͂̐�����
	* @return void
	*/
	void setOutput(const std::string& str);

	/**
	* ������ݒ肷��֐�
	* @param[in] str �T���v������
	* @return void
	*/
	void setSample(const std::string& str);

private:
	std::string problemTitle;
	std::string date;			//ex. 20141227	
	int problemNo;

};

#endif //PROBLEM_HTMLGENERATOR_H
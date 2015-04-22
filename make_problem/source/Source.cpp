/**
* @file source.cpp
*
* @mainpage
* �{�v���O�����́A���\�[�X�Ǝw�肳�ꂽJSON�t�@�C����p����web�T�C�g(�̖��\������)���o�͂���v���O�����ł���B
*
* @section �����̊T�v
* �{�v���O�����́A�R�}���h���C�������Ƃ��Ďx�����ꂽJSON�t�@�C���̓��e�����Ƃ�html���쐬���邽�߂ɍ쐬���ꂽ�B<br>
* ���͂����JSON�̕��@������������JsonValidator��p���Č��؂���̂ŁA���@�Ɍ�肪�������ꍇ�͂����ŏ������I������B<br>
* �܂��AJsonValidator��JAVA�ŏ�����Ă���v���O�������g�p���Ă��邽�߁A�{�v���O���������s����ɂ�JAVA�̎��s�����K�{�ł���B<br>
* �����āA���e�̌��؂��ς�Json��"picojson"�Ƃ������C�u������p���ăp�[�X���Ȃ���K�v�ȃf�[�^�𒊏o���Ahtml���쐬���Ă����B<br>
* �쐬����html�̂ЂȌ`�̓e���v���[�g�Ƃ���resoures�t�H���_�Ɋi�[����Ă���A
*
* - problemTemplate.html
* - listTemplate.html
* - tableTemplate.html
*
* ��3������ɓ�����B<br>
*
* @section �R���p�C�����@
* �{�v���O�����̃R���p�C���́AVisual Studio��p����ꍇ�͒ʏ�ʂ�̃r���h�ŉ\�ł���B<br>
* g++�ŃR���p�C������ꍇ�́A"-std=gnu++11"�I�v�V�������w�肵�A���ׂĂ�cpp�t�@�C�����w�肷��B<br>
*
* @section ���s�ɂ�������
* �{�v���O�����ł́A���͂���Json�t�@�C�������v���O�����N�����̃R�}���h���C�������Ƃ��ēǂݍ��܂���B<br>
* �����āA�T���v�����o�͂̓��e���i�[���ꂽ�t�@�C�����v���O�����Ɠ���t�H���_�ɔz�u����B<br>
* �܂��A�N���̍ۂ�resource�t�H���_���Ɉȉ��̃t�@�C���������Ă��Ȃ���ΐ���ɓ��삵�Ȃ��B<br>
* 
* - json-schema-validator-2.2.6-lib.jar
* - problemTemplate.html
* - listTemplate.html
* - tableTemplate.html
* - schema.json
*
* @section �쐬�����t�@�C��
* �v���O����������Ɏ��s�����ƁA�v���O�����Ɠ���K�w��"problem{���t}.html"���쐬�����B<br>
* �����āA"{���t}"�t�H���_���쐬����A���̒��Ɋe����html���z�u�����B
* 
* @section json�t�@�C���ɂ���
* json�t�@�C���̕��@�ɂ��ẮA�t����"JSON�\��.txt"�y��"schema.json"���Q�Ƃ��邱�ƁB
*
* @auther fujihiro_sn
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include "picojson.h"
#include "JsonValidator.h"
#include "StrReplacer.h"
#include "ListHtmlGenerator.h"
#include "ProblemHtmlGenerator.h"

void genListPage(picojson::object contestObj);
void genProblemPage(picojson::object contestObj);
std::string genSection(picojson::array section, std::string id, std::string class_);
std::string genSamples(picojson::array samples);



int main(int argc, char *argv[]) {

	using std::cout;
	using std::cerr;
	using std::cin;
	using std::endl;

	if (argc != 2) {
		cerr << "invalid argument" << endl;
		cerr << "usage : program.exe [contest json]" << endl;
		return 1;
	}
	
	JsonValidator test("./resources/schema.json");
	
	test.validation(argv[1]);

	std::string err = test.getError();
	if (!err.empty()) {
		cout << test.getError() << endl;
		cout << test.getErrorList() << endl;
		return 2;
	}
	
	std::ifstream ifs(argv[1]);
	picojson::value v;

	if (ifs.fail()) {		//missing file
		cout << "cannot open contest json" << endl;
		return 1;
	}

	ifs >> v;
	std::string perr = picojson::get_last_error();
	if (!perr.empty()) {	//�p�[�X���s
		cout << perr << endl;
		return 1;
	}

	//�����܂łőS�f�[�^�̌��؂��ς�ł���̂ŁA����ȍ~�f�[�^�̃`�F�b�N�͊�{�s��Ȃ�

	//�R���e�X�g�f�[�^�̃��C���I�u�W�F�N�g���擾
	picojson::object contestObj = v.get<picojson::object>()["contest"].get<picojson::object>();

	genListPage(contestObj);
	genProblemPage(contestObj);
	//cout << v.get<picojson::object>()["contest"].get<picojson::object>()["name"].get<std::string>() << endl;
	
	return 0;
}

/**
* ���t��������쐬����
* @param[in] date ���t��񂪊i�[���ꂽpicojson�I�u�W�F�N�g
* @return ���t�̕�����
*/
std::string genDate(picojson::object date) {
	std::stringstream ssm;
	
	ssm << date["year"].get<double>() << std::setw(2) << std::setfill('0') << date["month"].get<double>() << std::setw(2) << std::setfill('0') << date["day"].get<double>();
	return ssm.str();
}

/**
* ���ꗗ�y�[�W���쐬����
* @param[in] contestObj �R���e�X�g��񂪊i�[���ꂽpicojson�I�u�W�F�N�g
* @return void
*/
void genListPage(picojson::object contestObj) {

	ListHtmlGenerator listPage;

	listPage.setTitle(contestObj["name"].get<std::string>());
	listPage.setDate(genDate(contestObj["date"].get<picojson::object>()));

	picojson::array questions = contestObj["question"].get<picojson::array>();
	for (size_t i = 0; i < questions.size(); i++) {
		picojson::object question = questions[i].get<picojson::object>();
		std::string title = question["title"].get<std::string>();
		int timeLimit = question["time"].get<double>();
		int memLimit = question["mem"].get<double>();
		listPage.addProblemData(title, i + 1, timeLimit, memLimit);
	}

}

/**
* ���y�[�W���쐬����
* @param[in] contestObj �R���e�X�g��񂪊i�[���ꂽpicojson�I�u�W�F�N�g
* @return void
*/
void genProblemPage(picojson::object contestObj) {

	std::string date = genDate(contestObj["date"].get<picojson::object>());
	
	system(("mkdir " + date).c_str());	//�f�B���N�g���쐬

	picojson::array questions = contestObj["question"].get<picojson::array>();

	//��萔�����[�v
	for (size_t i = 0; i < questions.size(); i++) {
		ProblemHtmlGenerator problemPage;
		picojson::object question = questions[i].get<picojson::object>();

		//�K�v�ȏ����擾
		std::string title = question["title"].get<std::string>();
		int timeLimit = question["time"].get<double>();
		int memLimit = question["mem"].get<double>();

		//����ݒ肵�Ă���
		problemPage.setProblemInfo(title, timeLimit, memLimit);
		problemPage.setDate(date);
		problemPage.setProblemNum(i + 1, questions.size());

		problemPage.setStatement(genSection(question["statement"].get<picojson::array>(), "question", "sentence"));
		problemPage.setInput(genSection(question["input"].get<picojson::array>(), "input", "sample"));
		problemPage.setConstraints(genSection(question["constraints"].get<picojson::array>(), "constraints", "sentence"));
		problemPage.setOutput(genSection(question["output"].get<picojson::array>(), "output", "sample"));

		problemPage.setSample(genSamples(question["sample"].get<picojson::array>()));
	}

}

/**
* statement��input�Ȃǂ̐߂��쐬����
* @param[in] section �Z�N�V�����������i�[���ꂽpicojson�z��
* @param[in] id "input"��"output"���w��(html�̌����ڐ���p)(���݂͎g�p���Ă��Ȃ�)
* @param[in] class_ "sentence"��"sample"�����w��(html�̌����ڐ���p)
* @return �߂�html������
*/
std::string genSection(picojson::array section, std::string id, std::string class_) {
	std::stringstream ssm;

	for (auto j = section.begin(); j != section.end(); j++) {

		if (j->is<std::string>()) {		//sentense

			ssm << "\t\t<p class=\"sentence\">" << std::endl << "\t\t\t" << j->get<std::string>() << std::endl << "\t\t</p>" << std::endl;

		} else if (j->is<picojson::array>()) {		//array

			std::stringstream sample;
			for (auto k = j->get<picojson::array>().begin(); k != j->get<picojson::array>().end(); k++) {
				sample << k->get<std::string>() << "<br>";
			}

			ssm << "\t\t<div class=\"" << class_ << "\">" << std::endl;
			ssm << sample.str() << "</div>" << std::endl;

		} else if (j->is<picojson::object>()) {	//Image
			picojson::object& img = j->get<picojson::object>();
			if (img["image"].is<std::string>()) {
				std::string imgName = img["image"].get<std::string>();
				ssm << "\t\t<div class=\"image\"><img src=\"./" << imgName << "\"></div>" << std::endl;
			}
		}

	}
	return ssm.str();
}

/**
* �T���v���������쐬����֐�
* @param[in] samples �T���v���������i�[���ꂽpicojson�I�u�W�F�N�g
* @return �T���v��������html������
*/
std::string genSamples(picojson::array samples) {
	int sCounter = 1;	//�T���v���̌�

	std::stringstream ssm;
	for (auto j = samples.begin(); j != samples.end(); j++, sCounter++) {

		picojson::object& sampleObj = j->get<picojson::object>();

		std::ifstream iifs(sampleObj["sampleIn"].get<std::string>());
		std::ifstream iofs(sampleObj["sampleOut"].get<std::string>());

		// �t�@�C�����J���Ȃ������ꍇ*2
		if (iifs.fail()) {
			std::cerr << std::string("cannot open " + sampleObj["sampleIn"].get<std::string>()) << std::endl;
			exit(2);
		}
		if (iofs.fail()) {
			std::cerr << std::string("cannot open " + sampleObj["sampleOut"].get<std::string>()) << std::endl;
			exit(2);
		}
		// 2�̃C�e���[�^�ɓ��o�͂��ꂼ��̃t�@�C�����e��ǂݍ��܂���
		std::istreambuf_iterator<char> iIt(iifs), oIt(iofs);
		std::istreambuf_iterator<char> ilast, olast;
		std::string iStr(iIt, ilast), oStr(oIt, olast);

		// �ǂݍ��񂾃T���v�����e��html�Ƃ��Đ��`���Ă���
		// sample input
		ssm << "\t\t<h4>Sample Input " << sCounter << "</h4>" << std::endl;
		ssm << "\t\t<pre class=\"sample\">" << std::endl;
		ssm << iStr << "</pre>" << std::endl;
		// sample output
		ssm << "\t\t<h4>Sample Output " << sCounter << "</h4>" << std::endl;
		ssm << "\t\t<pre class=\"sample\">" << std::endl;
		ssm << oStr << "</pre>" << std::endl;

		// �摜����`����Ă�����
		if (sampleObj["image"].is<std::string>()) {
			std::string fileName = sampleObj["image"].get<std::string>();
			ssm << "\t\t<div class=\"image\"><img src=\"./" << fileName << "\"></div>" << std::endl;
		}

		//����������`����Ă�����
		if (sampleObj["string"].is<std::string>()) {
			ssm << "\t\t<p class=\"sentence\">" << std::endl << "\t\t\t" << sampleObj["string"].get<std::string>() << std::endl << "\t\t</p>" << std::endl;
		}


	}
	return ssm.str();
}


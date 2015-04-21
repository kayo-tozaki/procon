#include "JsonValidator.h"
#include <sstream>
#include <string>
#include <fstream>


const std::string JsonValidator::c_command = "java -jar ./resources/json-schema-validator-2.2.6-lib.jar";
const int c_bufSize = 256;

JsonValidator::JsonValidator(std::string str) : m_schemaPath(str), m_errStr() {
}

JsonValidator::~JsonValidator() {
}

void JsonValidator::setSchema(const std::string& filePath) {
	m_schemaPath = filePath;
}


std::string JsonValidator::getError() {
	return m_errStr;
}

std::string JsonValidator::getErrorList() {
	return m_errList;
}

void JsonValidator::validation(const std::string& filePath) {

	std::ifstream ifs;

	ifs.open(filePath, std::ios::in);
	if (ifs.fail()) {		//missing file
		m_errStr = "cannot open file";
		m_errList = "missing " + filePath;
		return;
	}
	m_errList = checkSyntax(ifs);
	if (!m_errStr.empty()) {	//syntax error
		return;
	}

	ifs.close();

	//call json validator with -q mode
	int result = system((c_command + " " + m_schemaPath + " " + filePath + " -q").c_str());

	switch (result) {
		case 0:		//validation successful
			m_errStr = "";
			break;
		case 1:		//exception occurred (appears on stderr)
			m_errStr = "exception occurred (appears on stderr)";
			break;
		case 2:		//command line syntax error (missing argument, etc)
			m_errStr = "command line syntax error (missing argument, etc)";
			break;
		case 100:	//one or more file(s) failed validation
			m_errStr = "one or more file(s) failed validation";
			m_errList = genErrList(filePath);
			break;
		case 101:	//one or more schema(s) is/are invalid
			m_errStr = "one or more schema(s) is/are invalid";
			break;
		default:
			m_errStr = "Unknwon states";
			break;
	}

}

std::string JsonValidator::genErrList(const std::string& filePath) {
	
	FILE *output;

#ifdef _MSC_VER
	if (!(output = _popen((c_command + " " + m_schemaPath + " " + filePath).c_str(), "r"))) {
		return std::string();
	}
#else
	if (!(output = popen((c_command + " " + m_schemaPath + " " + filePath).c_str(), "r"))) {
		return std::string();
	}
#endif //_MSC_VER

	char buf[c_bufSize];
	std::stringstream ssm;

	while (fgets(buf, c_bufSize, output)) {
		ssm << buf;
	}
	
#ifdef _MSC_VER
	_pclose(output);
#else
	pclose(output);
#endif //_MSC_VER

	return ssm.str();
}

std::string JsonValidator::checkSyntax(std::ifstream& ifs) {
	picojson::value v;

	ifs >> v;
	std::string err = picojson::get_last_error();
	if (!err.empty()) {	//ÉpÅ[ÉXé∏îs
		return err;
	}

	return std::string();
}

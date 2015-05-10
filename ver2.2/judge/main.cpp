#include <iostream>
using namespace std;

int main() {
	double a;
	cin >> a;
	cout << fixed;
	cout.precision(1);
	cout << (a*a*a*a*a*a*a*a + 6*a) /2<< "\n";
	return 0;
}
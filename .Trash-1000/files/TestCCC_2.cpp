#include <iostream>
 
using namespace std;
 
int
main(int argc, char const* argv[])
{
        struct X { int n; };
        constexpr X x = {123};
        int a[x.n] = { 1 };
        return 0;
}
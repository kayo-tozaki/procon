#include <stdio.h>
#include <math.h>



int main(void){
	int a = 0;
	int data[100000];
	int count = 0;
	double tmp = 0;


	scanf("%d",&a);
	tmp = sqrt(a);
	int f = 0;
	for(int i=2; i<=3;i++){
		while(a-i>2){
			if(f==0){
				f=1;
			}else{
				printf(" + ");
			}
			printf("%d",i);
			a-=i;

		}

//	printf("%d\n",a);
	}
	if(a==2)printf("2");
	else if(a==3)printf("3");
	else if(a!=0)printf(" + 3");
//	if(f==0)printf("%d",a);
	printf("\n");

return 0;
}
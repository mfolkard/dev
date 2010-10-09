#include <stdio.h>

void my_swap(void *vp1, void *vp2){
	char *tmp = (char *)vp1;
	vp1 = vp2;
	vp2 = tmp;
}

main(){
	int *in1, *in2;
	in1 = 3;
	in2 = 9;
	printf("in1:%d, in2:%d\n", in1, in2);
	my_swap(&in1, &in2);
	printf("in1:%d, in2:%d\n", in1, in2);
}

#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int *integers;
	int cur_pointer;
	int stack_size;
} stack;

void stackNew(stack *s, int s_size){
	s->cur_pointer = 0;
	s->stack_size = s_size;
	s->integers = malloc(s_size * sizeof(int));
	//assert(s->integers != NULL);
}

void stackDispose(stack *s){
	free(s->integers);
}

void stackPush(stack *s, int n){
	if(s->cur_pointer == s->stack_size){
		int *i_tmp = malloc((s->stack_size + 4) * sizeof(int));
		memcpy(i_tmp, s->integers, s->stack_size*sizeof(int));
		s->integers = i_tmp;
		s->stack_size = (s->stack_size + 4);
	}
	s->integers[s->cur_pointer] = n;
	s->cur_pointer++;
}

int stackPop(stack *s){
	s->cur_pointer--;
	return s->integers[s->cur_pointer];
}


main(){
	stack *s;
	stackNew(&s, 4);
	int i;
	for(i=0; i<6; i++){
		printf("pushing:%d\n", i);
		stackPush(&s, i);
	}

	for(i=0; i<6; i++){
		printf("popping:%d\n", stackPop(&s));
	}
	stackDispose(&s);
}

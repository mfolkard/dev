#include <stdio.h>

main(){
	printf("This is a test program...\n");
	char *test_message, *tmp;
	char tmp_arr[100];
	tmp = "blah blah blah blah";
	test_message = "hello, this is a test message";
	stringCopy(tmp_arr, "hello");
	printf("tmp --- %s\ntest_message --- %s\n", tmp, test_message);
	test_message = "New string";
	printf("tmp --- %s\ntest_message --- %s\n", tmp, test_message);

	printf("String length of \"%s\", is %d\n", test_message, myStrLen(test_message));


	char *str_one = "hello";
	char *str_two = "hello";
	printf("s1 is %s\ns2 is %s\n are they the same??...%d\n", str_one, str_two, myStrCmp(str_one, str_two));

	char source[100];
	char *target = "hello";
	theirStrCopy(source, "bob");
	printf("s1 is %s\ns2 is %s\n", source, target);
	myStrCat(source, target);
	printf("the concat is %s\n", source);
	
}




void myStrCat(char *s, char *t){
	while(*s != '\0') {
		s++;
	}

	while(*t != '\0') {
		*s = *t;
		s++;
		t++;
	}
}





void stringCopy(char *to, char *from){
	while(*from != '\0'){
		*to = *from;
	//printf("%s\n", from);
  	from++;
	to++;
	
	}

}


void theirStrCopy(char *s, char *t){
	while((*s = *t) != '\0'){
		s++;
		t++;
	}
}


int myStrLen(char *s){
	int i;
	for (i = 0; *s != '\0'; i++)
		s++;
	return i;
}


int myStrCmp(char *s, char *t){
	while(*s != '\0'){
		if(*s != *t){
			return 0;
	    }
		else {
			s++;
			t++;
		}
	}
	return 1;
}



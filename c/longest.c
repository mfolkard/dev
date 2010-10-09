#include <stdio.h>

#define MAXLINE 1000

main(){
	char line[MAXLINE];
	char max_line[MAXLINE];
	int max = 0;
	int len;

	while((len = getLine(line)) > 0){
		if (len > max){
			max = len;
			copystr(line, max_line);
		}
	}
	printf("%s\n", max_line);
}

int getLine(char line_arr[]){
	char c;
	int len = 0;
	int count = 0;
	
	int i;
	
	for(i=0; i<MAXLINE-1 && ((c = getchar()) != EOF) && c != '\n'; ++i){
		//printf("%c\n", c);
		line_arr[i] = c;
		++len;
	}
	if(c == '\n'){
		line_arr[i] = c;
		++len;
	}
	line_arr[i] = '\0';
   	printf("%s - %d\n", line_arr, len);
	return len;
}

void copystr(char from[], char to[]){
	int i = 0;
	while((to[i] = from[i]) != '\0'){
		++i;
	}
}

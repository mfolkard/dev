#include <stdio.h>

#define MAXSTRINGS 1000
#define MAXLENGTH 1000

char *lines[MAXSTRINGS];

main(){
	char *c[MAXSTRINGS];
	//getLine(c);
	//printf("here is the string you typed: %s\n", c);
	//char *words[] = {"hello", "mark"};
	//printLines(2, words);
	int num_lines = getLines(c);
	sortLines(c, num_lines-1, 0);
	printLines(num_lines, c);
	//printLines(1, c);
	/*char words[100][100];
	words[0] = "hello";
	words[1] = "bob";
	printLines(2, words);*/
}


void sortLines(char *lines[], int t, int b){
	int top = t;
	int bottom = b;
	int pivot = (bottom+top)/2;
	char *cmp_elem = lines[pivot];
	/*printf("cmp_elem is %s\n", cmp_elem);
	printf("bottom_elem is %s\n", lines[bottom]);
	printf("strcmp is %d\n", strcmp(cmp_elem, lines[bottom]));*/
	do {
		while (strcmp(cmp_elem, lines[bottom]) > 0) bottom++;
		while (strcmp(cmp_elem, lines[top]) < 0) top--;

		if (bottom <= top){
			char *tmp = lines[bottom];
			lines[bottom] = lines[top];
			lines[top] = tmp;
			bottom++;
			top--;
		}
		
	} while (bottom <= top);

	if(b < top)
		sortLines(lines, top, b);
	if (bottom < t)
		sortLines(lines, t, bottom);
}


int getLines(char *lines[]){
	char line_buffer[MAXLENGTH];
	int len;
	int lines_no = 0;
	int line_count = 0;
	char *p;
	//int len = readLine(line_buffer);
	while((len = readLine(line_buffer)) > 0){
		if(lines_no++ > MAXSTRINGS || (p = malloc(len)) == NULL){
			return -1;
		} else {
			strcpy(p, line_buffer);
			lines[line_count++] = p;
		}
	}
	return lines_no;
}

int readLine(char *c_arr){
	int l = 0;
	char c;
	while((c = getchar()) != EOF && c != '\n'){
		*c_arr++ = c;
		l++;
	}
	if(c == '\n'){
		*c_arr = c;
		l++;
	}
	*c_arr = '\0';
	return l;
}


void printLines(int arr_count, char *c[]){
	int orig = arr_count;
	//printf("%s\n", c[0]);
	//printf("%s\n", c[1]);
	while (arr_count != 0){
		//printf("%d, %d\n", orig, arr_count);
		printf("%s\n", c[orig-arr_count]);
		//printf("%s\n", c);
		arr_count--;
		//c++;
	}
}

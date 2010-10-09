#include <stdio.h>

int StringCompare(void *vp1, void *vp2){
	char *st1 = *(char **)vp1;
	char *st2 = *(char **)vp2;
	return strcmp(st1, st2);
}

void * my_lsearch(void *key, void *base, int a_size, int elemSize, int (*cmp_func)(void *, void *)){
	int i;
	for(i=0; i<a_size; i++){
		void *elem = (char *)base + (i * elemSize);
		if(cmp_func(key, elem) == 0){
			return elem;
		}
	}
	return NULL;
}




main(){
	char *notes[] = {"C", "C#", "D", "D#", "E"};
	char *find_note = "C#";
	int arr_size = 5;
	char **found = my_lsearch(&find_note, notes, arr_size, sizeof(char*), StringCompare);
	if(found != NULL){
		printf("Found: %s\n", *found);
	} else {
		printf("Not Found\n");
	}
}


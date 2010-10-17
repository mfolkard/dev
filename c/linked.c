#include <stdio.h>

void print_next_item(struct *l_list_item, int);

struct l_list_item {
	struct l_list_item *next;
	char *obj;
};

struct l_list {
	struct l_list_item *start;
};



/*Initialiser for the list, just set it to the ether*/
void create_list(struct l_list *l){
	l->start = NULL;
}

/*Add the given item to the given list, and set the list pointers appropriately */
int l_list_add(struct l_list *l, struct l_list_item *it){
	if(l->start == NULL){
		l->start = it;
		it->next = NULL;
	} else {
		it->next = l->start;
		l->start = it;
	}
}

/*Prints out the list*/
void print_list(struct l_list *l){
	struct l_list_item *current;
	int count = 0;
	current = l->start;
	do {
		count++;
		printf("Item %d is %s\n", count, current->obj);
		current = current->next;
	} while (current != NULL);
}

/*Prints out the list in reverse order.*/
void reverse_print_list(struct l_list *l){
	print_next_item(l->start, 1);
	
}

/*Recursive function to print print the given item if none follow it
or move to the next one, and then print the current one*/
void print_next_item(struct l_list_item *item, int count){
	if(item->next == NULL){
		printf("Item %d is %s\n", count, item->obj);
	} else {
		print_next_item(item->next, count+1);
		printf("Item %d is %s\n", count, item->obj);
	}
}

/*Sets up a list item*/
void create_item(struct l_list_item *item, char *obj){
	item->next = NULL;
	item->obj = obj;
}

int main(){
	struct l_list list;
	create_list(&list);
	char *str1 = "mark";
	struct l_list_item it_1;
	create_item(&it_1, str1);
	l_list_add(&list, &it_1);
	char *str2 = "is";
	struct l_list_item it_2;
	create_item(&it_2, str2);
	l_list_add(&list, &it_2);
	char *str3 = "name";
	struct l_list_item it_3;
	create_item(&it_3, str3);
	l_list_add(&list, &it_3);
	char *str4 = "my";
	struct l_list_item it_4;
	create_item(&it_4, str4);
	l_list_add(&list, &it_4);
	printf("The list going forward is:\n");
	print_list(&list);
	printf("The list going backward is:\n");
	reverse_print_list(&list);
}

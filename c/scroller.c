#include <stdio.h>
#include <unistd.h>
#include "chars.h"

#define CHAR_WIDTH 6
#define CHAR_HEIGHT 6
#define BOARD_WIDTH 10*CHAR_WIDTH
#define BOARD_HEIGHT CHAR_HEIGHT

int main(){
	char *message = "HELLO MUM HOW ARE YOU";

	int board[BOARD_WIDTH][BOARD_HEIGHT];
	initBoard(board);
	int mess_length = strlen(message);
	int i, c, w, a;
	for(i = 0; i < mess_length; i++){
		int char_index = encodeChar(message[i]);
		for(c=0; c< CHAR_WIDTH; c++){
			rotateBoard(board);
			for(w=0; w < BOARD_HEIGHT; w++){
				board[BOARD_WIDTH-1][w] = chars[char_index][w][c];
			}
			system("clear");
			printBoard(board);
			usleep(25000);
		}
		rotateBoard(board);
		for(a=0; a < BOARD_HEIGHT; a++){
			board[BOARD_WIDTH-1][a] = 0;
		}
	}
}

void rotateBoard(int b[BOARD_WIDTH][BOARD_HEIGHT]){
	int x, y;
	for(x=0; x < BOARD_HEIGHT; x++){
		for(y=0; y < BOARD_WIDTH-1; y++){
			b[y][x] = b[y+1][x];
		}
	}
}

void initBoard(int b[BOARD_WIDTH][BOARD_HEIGHT]){
	int x, y;
	for(x=0; x < BOARD_HEIGHT; x++){
		for(y=0; y < BOARD_WIDTH; y++){
			b[y][x] = 0;
		}
	}
}


int encodeChar(int c){
	int count = 0;
	int x;
	for(x=0; x<27; x++){
		if(letters[x] == c){
			return x;
		}
	}
	return -1;
}


void printBoard(int b[BOARD_WIDTH][BOARD_HEIGHT]){
	int x, y;
	for(x=0; x < BOARD_HEIGHT; x++){
		for(y=0; y < BOARD_WIDTH; y++){
			if(b[y][x] == 1){
				printf("#");
			} else {
				printf(" ");
			}
		}
		printf("\n");
	}
}

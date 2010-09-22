#! /usr/bin/env python

import chars
import os
import time

def printBoard(b):
    for x in range(board_height):
        for y in range(board_width):
            if b[y][x] == 0:
            	print " ",
            else:
            	print "#",
	print ""

def printMessage(m):
	for c in range(len(m)):
            enc_c = encodeChar(m[c:c+1])
            for x in range(char_width):
                os.system("clear")
		rotateBoard(board)
                for y in range(board_height):
                	board[board_width-1][y] = enc_c[y][x]
		
            	#print m[c:c+1]
            	printBoard(board)
                time.sleep(0.25)
            rotateBoard(board)
	    for y in range(board_height):
        	board[board_width-1][y] = 0

def encodeChar(c):
	count = 0
	for x in chars.letters:
		if x == c:
                	return chars.chars[count]
		count = count+1
	return None

def rotateBoard(b):
	for x in range(board_height):
	        for y in range(board_width-1):
			b[y][x] =  b[y+1][x]

def printEncChar(c):
    for x in range(char_height):
        for y in range(char_width):
            if c[x][y] == 0:
            	print " ",
            else:
            	print "#",
	print ""

char_width = 6
char_height = 6
board_width = 4*char_width
board_height = char_height
message = "HELLO ALEX HOW ARE YOU"


#2D array representing the output; board [width][height]
board = []
for x in range(board_width):
	board.append([])
        for y in range(board_height):
		board[x].append([])
	

for x in range(board_width):
	board.append([])
        for y in range(board_height):
		board[x][y] = 0#x, "-", y

#printBoard(board)
#rotateBoard(board)
#print ""
#printBoard(board)
printMessage(message)


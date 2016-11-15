/*********************/
/* Trever Wagenhals  */
/* Prog7_rasper      */
/* 4/13/2015         */
/*********************/

/****************************************************************************************************/
/* This program will allow the user to specify where in a 50 by 20 grid they would like to begin    */
/* adding stars, assigned by rows and columns to fill in. The user then can print the current       */
/* image, add more stars, reset the grid back to default, or exit the program                       */
/****************************************************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#define Nrows 21					//dimensions	
#define Ncols 51

#include <stdio.h>
#include <string.h>
#include <ctype.h>

//Function prototypes

//Uses a specified width and height to add box to existing grid starting at specified (x, y) 
void addBox(char grid[][Ncols], int x, int y, int width, int height);

//When the user enters 'reset', function will clear grid
void resetGrid(char grid[][Ncols]);

//Prints current grid
void printGrid(char grid[][Ncols]);

void main(){
	char Grid[Nrows][Ncols];						//grid to be used
	int i = 0;										//index

	//character arrays
	char command[6];								//user commands
	char print[] = "print";
	char exit[] = "exit";
	char reset[] = "reset";
	char add[] = "add";

	//User inputs
	int xCoor, yCoor;								//x/y coordinates
	int gridWidth, gridHeight;						//grid width & height


	//Start of program
	resetGrid(Grid);								//clear grid to default state

	do{
		printf("\nEnter command: ");
		scanf("%s", &command);
		for (i = 0; i < 6; i++)
			command[i] = tolower(command[i]);

		if (strcmp(print, command) == 0)
		{
			printGrid(Grid);
		}
		else if (strcmp(reset, command) == 0)
		{
			resetGrid(Grid);
		}
		else if (strcmp(add, command) == 0)
		{
			printf("Enter X and Y coordinatss for origin: ");
			scanf("%d %d", &xCoor, &yCoor);
			printf("Enter width and height: ");
			scanf("%d %d", &gridWidth, &gridHeight);
			addBox(Grid, xCoor, yCoor, gridWidth, gridHeight);
		}
		else if (strcmp(exit, command) == 0)
		{
			return;
		}
		else 
		{
			printf("Error: Invalid command %s\n", command);
		}
	} while (strcmp(exit, command) != 0);
}

// Definition of functions
// creates exsisting grid with specified width and height
void addBox(char grid[][Ncols], int x, int y, int width, int height)
{
	int i, j; // index

	//condition statements
	if (x < 0)
	{
		width += x;
		x = 0;
	}
	else if (y < 0)
	{
		height += y;
		y = 0;
	}
	else if (x > Ncols - 1)
	{
		width = 0;
	}
	else if (y > Nrows - 1)
	{
		height = 0;
	}
	while (y + height > Nrows)
		height--;
	while (x + width > Ncols)
		width--;

	y = -1 * y + 20;									// (0-20) from bottom

	//prints *'s
	for (i = 0; i < width; i++) 
	{
		for (j = 0; j < height; j++) 
		{
			grid[y + j - height + 1][x + i] = '*';
		}
	}
}

//Print current grid contents
void printGrid(char grid[][Ncols]) 
{
	int i, j; // indexes

	for (i = 0; i < Nrows; i++) 
	{
		for (j = 0; j < Ncols; j++) 
		{
			printf("%c", grid[i][j]);
		}
		if (i % 5 == 0)
		{
			printf("%2d", 20 - i);
		}
		printf("\n");
	}
	printf("0    5    10   15   20   25   30   35   40   45   50\n");
}

// Resets the grid to original settings
void resetGrid(char grid[][Ncols]) 
{
	int i, j; // indexes

	for (i = 0; i < Nrows; i++) 
	{
		for (j = 0; j < Ncols; j++) 
		{
			grid[i][j] = ' ';
			if (i % 5 == 0 && j % 5 == 0)
			{
				grid[i][j] = '+';
			}
			else if (i % 5 == 0)
			{
				grid[i][j] = '-';
			}
			else if (j % 5 == 0)
			{
				grid[i][j] = '|';
			}
		}
	}
}



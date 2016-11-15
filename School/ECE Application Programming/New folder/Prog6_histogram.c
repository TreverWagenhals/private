/************************/
/* Trever Wagenhals     */
/* March 5, 2015        */
/* Prog6_histogram      */
/************************/


/************************************************************/
/*This program reads the user's input and displays          */
/*how many different letters appear in the input using      */
/*a histogram                                               */
/************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <ctype.h>
#define ALPHABET 26

//Function Prototypes
void ReadText(int histo[], int *max);		//Reads single line of text, updates histogram
											//and updates the most frequent letter*/
void DrawHistogram(int histo[], int max);	//Prints histogram, using array holding frequency values
											//and determines height

void main(){
	char command;							//operation used (c,r,p,q)
	int histarray[ALPHABET] = { 0 };		//Array for alphabet
	int maxLetter = 0;						//Count of letters
	int i;									//index	

	do{
		printf("\nEnter command (C, R, P or Q): ");
		scanf(" %c", &command);
		switch (command){
		case 'C': case 'c':							 //Reset histogram
			maxLetter = 0;
			for (i = 0; i < ALPHABET; i++)
				histarray[i] = 0;
			break;
		case 'R': case 'r':							//Read inputted data
			ReadText(histarray, &maxLetter);
			break;
		case 'P': case 'p':							//Print current histogram
			DrawHistogram(histarray, maxLetter);
			break;
		case 'Q': case 'q':							//End program
			return;
		default:
			printf("Invalid command %c\n", command);
			break;
		}
	} while (command != 'Q' || command != 'q');
}

// Reads single line of text and updates histogram
// with most frequent letter
void ReadText(int histo[], int *max){
	char ch;
	int i;

	printf("\nENTER A LINE OF TEXT:\n\n");
	scanf("%c", &ch);

	//scan each letter and assigns them to an element
	do{
		scanf("%c", &ch);
		if (isalpha(ch) > 0){						//This function returns a non-zero value if ch is a letter of the alphabet, and zero otherwise
			ch = toupper(ch);						//If ch is an lowercase letter, this function returns the uppercase version. Otherwise,
													//toupper() returns the original value of ch.
			for (i = 0; i < ALPHABET; i++){
				if (ch == 'A' + i){
					histo[i]++;
				}
			}
		}
	} while (ch != '\n');

	//setting a max
	for (i = 0; i < ALPHABET; i++){
		if (histo[i] > *max)
			*max = histo[i];
	}
}

// Prints Historgram and determines max height
void DrawHistogram(int histo[], int max){
	int i;
	int histoCopy[ALPHABET] = { 0 };
	int nmax = max;									//number of max values in histocopy

	printf("\nLETTER FREQUENCIES IN TEXT:\n\n");
	for (i = 0; i < ALPHABET; i++)
		histoCopy[i] = histo[i];
	do{
		for (i = 0; i < ALPHABET; i++){
			if (histoCopy[i] == nmax && histoCopy[i] != 0){
				printf("| ");
				histoCopy[i]--;
			}
			else
				printf("  ");
		}
		nmax--;
		printf("\n");
	} while (nmax > 0);

	printf("+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-\n");
	printf("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z\n");
}
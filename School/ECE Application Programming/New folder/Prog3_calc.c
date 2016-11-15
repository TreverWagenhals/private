/*********************/
/* Trever Wagenhals  */
/* Prog3_calc        */
/* 2/23/2015         */
/*********************/

/****************************************************************************************************/
/* This program will ask the user to enter the precision to assign two variables, what those two    */
/* variables are, and if the user wants to add, subtract, multiply, or divide them, and the posts   */
/* the total equation with the answer to the precision that they initially stated                   */
/****************************************************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

//main will perform all calculations and output all data mentioned in program summary.
int main()
{
	int p;					//holds the precision point value
	double variable1;		//first variable to alternate	
	double variable2;		//second variable to alternate	
	char symbol;			//assign an operand to alternate the variables by
	double total;			//value of the variables altered by the operand
	int nVals;				//counter to ensure all three inputs are correctly formatted

	printf("Enter Precision: ");		
	scanf("%int \n", &p);

	if (p > 0)					//if statement to make sure to only continue if the precision is greater than 0
	{
		printf("Enter Expression: ");
		nVals = scanf("%lf %c %lf", &variable1, &symbol, &variable2); // counter to make sure that all three inputs are in proper format

		if (nVals == 3)			//only continue testing if all three formats are correct
		{
			switch (symbol)
			{
			case '+':								//if the user wants to use addition
				total = variable1 + variable2;		//assigns value to total to call on later
				printf("%.*lf %c %.*lf = %.*lf \n", p, variable1, symbol, p, variable2, p, total);
				break;
			case '-':								//if user wants to use subtraction
				total = variable1 - variable2;
				printf("%.*lf %c %.*lf = %.*lf \n", p, variable1, symbol, p, variable2, p, total);
				break;
			case '/':								//if user wants to use division
				if (variable2 == 0)					//if user tries to divide by 0, produce error
					printf("Error: Cannot divide by zero \n");
				else if (variable2 != 0)
				{
					total = variable1 / variable2;	//if divisor is not 0, assign value to total
					printf("%.*lf %c %.*lf = %.*lf \n", p, variable1, symbol, p, variable2, p, total);
				}
				break;
			case '*':								//if user wants to use multiplication
				total = variable1 * variable2;
				printf("%.*lf %c %.*lf = %.*lf \n", p, variable1, symbol, p, variable2, p, total);
				break;
			default:								//if the character input does not represent one of the four math s
				printf("Error: Incorrectly Formatted input \n");
			}
		}
		else
			printf("Error: Incorrectly formatted input \n");	//if the counter did not equal three, skip switch statement and output error
	}
	else
		printf("Error: Negative Precision \n");		//if the user inputs a precision less than 0, produce error

	return 0;
}
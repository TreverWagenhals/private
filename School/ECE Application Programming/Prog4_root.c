/*********************/
/* Trever Wagenhals  */
/* March 4, 2015     */
/* Prog4_root        */
/*********************/

/*****************************************************************************/
/* This program will ask the user to enter a real number and an integer,     */
/* and then take the nth root of that real number. The program will continue */
/* to loop as long as the user says yes                                      */
/*****************************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

/********************************************************/
/* Contains the entire process discussed in the summary */
/********************************************************/
int main()
{
	double A;						//real number user will input
	int n;							//integer to take the root by
	int nVals;						//make sure that the users input is in proper format
	char junk;						//clear the users input and ask it again if incorrect
	double x;						//the final output after the root division
	int i;							//counter for for loop
	double decimal;					//ensure that this calculation is so low it is unecessary to continue testing
	double A_nth;					//this will be assigned the new value of x each loop
	char yes_no;					//ask the user to continue the program or not
	double f_prime;					//used in Newton's method 
	double f;						//used in Newton's method

	do
	{
		do
		{
			printf("Enter real number and integer (A n): ");
			nVals = scanf("%lf %d", &A, &n);													//assign a value to nVals equal to the correct inputs

			if (nVals != 2)
			{
				printf("Incorrectly formatted input \n");										//make sure the user knows the format that they entered is incorrect
				do
				{
					scanf("%c", &junk);
				} while (junk != '\n');															//clear the value stored to the users input so that program doesn't get stuck in loop
			}
			else if (n <= 1)																	//ensure n > 1 and let user know if not
				printf("Error: n must be positive integer >= 2 \n");
			else if (A < 0)																		//ensure A >= 0 and let user know if not
				printf("Error: value of A must be positive \n");

		} while ((nVals != 2) || (n <= 1) || (A < 0));											//continue program until all test conditions are met

		x = 10;																					//assign an initial guess value to begin calculation

		do
		{
			A_nth = x;																			//assign value so that A_nth can be x^1 for future calculations when x's value changes

			for (i = 1; i < n; i++)																//for loop to multiply x by itself as many times as the value of n
			{
				x = x* A_nth;
			}

			f_prime = n * (x / A_nth);															//calculate the derivative of the root entered with respect to the value of x
			f = x - A;												
			decimal = f / f_prime;
			x = A_nth - decimal;																//Newtons method of approximation

			if ((decimal < 0.000001) && (decimal > -0.000001))									//only finally output the answer when the decimal is so small that it doesn't alter x
				printf("Given A = %.2lf and n = %d, root = %.2lf \n", A, n, x);
		} while ((decimal > 0.000001) || (decimal < -0.000001));								//Only leave loop when value is printed and decimal is negligible

		do
		{
			printf("Calculate another root (Y/N)? ");
			scanf(" %c", &yes_no);
			if ((yes_no != 'y') && (yes_no != 'Y') && (yes_no != 'n') && (yes_no != 'N'))		//error message if response isn't in yes no format
				printf("Invalid response %c \n", yes_no);
		} while ((yes_no != 'y') && (yes_no != 'Y') && (yes_no != 'n') && (yes_no != 'N'));		//continue asking until response is in yes no format

	} while ((yes_no == 'y') || (yes_no == 'Y'));												//finally exit program when user says to

	return 0;
}

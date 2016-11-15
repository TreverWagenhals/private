/************************/
/* Trever Wagenhals     */
/* February 23, 2015    */
/* Prog5_integral       */
/************************/

/**********************************************************************************************/
/* This program will calculate the approximation of an integral using the trapezoidal method  */
/**********************************************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <math.h>

void main()
{
	int nVals;		 //how many valid inputs
	int nTraps;		 //how many trapezoids
	double high;	 //the high endpoint
	double low;		 //the low endpoint
	char rerun;		//option to repeat program answer (yes/no)
	char bad;		 //invalid values
	double integration(double a, double b, int n); //integrated


	do{
		// Determines the endpoints of the integral and makes sure it is a correct format
		do{
			printf("\nEnter endpoints of interval to be integrated (low high): ");
			nVals = scanf("%lf %lf", &low, &high);
			if (low >= high){
				printf("Error: low must be less than high\n");
				do{
					scanf("%c", &bad);
				} while (bad != '\n');
			}
			else if (nVals != 2){
				printf("Error: Improperly formatted input\n");
				do{
					scanf("%c", &bad);
				} while (bad != '\n');
			}
		} while (low >= high || nVals != 2);

		// Defines the number of trapezoids to apply to the Riemmans sum
		do{
			printf("Enter number of trapezoids to be used: ");
			nVals = scanf("%d", &nTraps);
			if (nTraps < 1 && nVals == 1){
				printf("Error: Number must be greater than or equal to 1\n\n");
				do{
					scanf("%c", &bad);
				} while (bad != '\n');
			}
			else if (nVals != 1){
				printf("Error improperly formatted input\n\n");
				do{
					scanf("%c", &bad);
				} while (bad != '\n');
			}
			else{
				printf("Using %d trapezoids, integral between %lf and %lf is %lf\n", nTraps, low, high, integration(low, high, nTraps));
			}
		} while (nTraps < 1 || nVals != 1);


		//Repeat the program if user says to
		do{
			printf("Evaluate another interval (Y/N)? ");
			scanf(" %c", &rerun);
			if (rerun == 'N' || rerun == 'n')
				return;
			else if (rerun == 'Y' || rerun == 'y')
				break;
			else{
				printf("Error: Must enter Y or N\n\n");
				do{
					scanf("%c", &bad);
				} while (bad != '\n');
			}
		} while (rerun != 'y' || rerun != 'Y');
	} while (rerun == 'y' || rerun == 'Y');
}
double f(double x){
	//Function being integrated		
	return sin(x) + (x*x / 10);
}

double integration(double a, double b, int n){
	//Approximate integral using trapezoidal method

	double bval = b;	// b value
	int n2 = n;			// n value 
	double base;		//trapezoid base
	double add = 0;		//initial addition
	double f(double x); //double

	base = (b - a) / n;
	do{
		bval -= base;
		add = f(bval) + add;
	} while (bval > a + base);
	return 0.5*base*(f(a) + f(b) + 2 * add);
}
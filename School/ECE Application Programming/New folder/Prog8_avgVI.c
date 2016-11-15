/*********************/
/* Trever Wagenhals  */
/* Prog8_avgVI       */
/* 4/21/2015         */
/*********************/

/***********************************************************************/
/* This program takes data stored in a set of binary files             */
/* and outputs the results to a text file based on the user's input    */
/***********************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	int i, h, k, l, m, p, r, s, t, v;									// Variables
	int n;																// Values scanned in
	double res[20], voltage[20], current[20], power[20];				// Arrays
	double maxpower, maxcurrent, maxvolt;								// Nax power and current variables
	double averagepower, avgcurrent, avgvolt;							// Average values for power,current and voltage
	double minimumpower, mincurrent, minvolt;							// Minimum values for power and current
	double powersum, currentsum, voltsum;								// Summation to find average power
	char resFileName[20], voltageFileName[20];							// Names of input files
	char output[20];													// Name of output file
	FILE *resFile;														// Declaring Files
	FILE *voltageFile;
	FILE *outputFile;

	v = 0;																// Tells loop to end

	while (v != 1)
	{																	// Pick resistor file 1 2 or 3
		printf("Enter name of file for resistor input: ");
		scanf("%s", resFileName);

		if (strcmp(resFileName, "resfile1.bin") == 0 || strcmp(resFileName, "resfile2.bin") == 0 || strcmp(resFileName, "resfile3.bin") == 0)
			v = 1;
		else
			printf("Invalid file name.\n\n");

	}

	v = 0;

	while (v != 1)
	{
		printf("Enter name of file for voltage input: ");				// Pick voltage 1 2 or 3
		scanf("%s", voltageFileName);

		if ((strcmp(voltageFileName, "voltfile1.bin") == 0) || (strcmp(voltageFileName, "voltfile2.bin") == 0) || (strcmp(voltageFileName, "voltfile3.bin") == 0))
			v = 1;
		else
			printf("Invalid file name.\n\n");
	}

	printf("Enter name name of file for output: ");						// Create output file name
	scanf("%s", output);

	resFile = fopen(resFileName, "r");
	voltageFile = fopen(voltageFileName, "r");
	outputFile = fopen(output, "w");

	n = fread(res, sizeof(double), 20, resFile);
	fread(voltage, sizeof(double), 20, voltageFile);



	for (i = 0; i<n; i++)
	{														
		current[i] = voltage[i] / res[i];								// Array values
	}

	for (h = 0; h<n; h++)
	{
		power[h] = voltage[h] * current[h];
	}

	maxpower = power[0];												// Initialize max power
	minimumpower = power[0];
	for (k = 0; k<n; k++)
	{
		if (power[k]>maxpower)
			maxpower = power[k];
		if (power[k]<minimumpower)
			minimumpower = power[k];
	}

	maxvolt = voltage[0];
	minvolt = voltage[0];
	for (l = 0; l<n; l++)
	{
		if (voltage[l]>maxvolt)
			maxvolt = voltage[l];
		if (voltage[l]<minvolt)
			minvolt = voltage[l];
	}

	maxcurrent = current[0];										// Initial max power set
	mincurrent = current[0];
	for (m = 0; m<n; m++)
	{
		if (current[m]>maxcurrent)
			maxcurrent = current[m];
		if (current[m]<mincurrent)
			mincurrent = current[m];
	}

	voltsum = 0;
	currentsum = 0;
	powersum = 0;

	for (p = 0; p<n; p++)
	{
		voltsum += voltage[p];
	}
	avgvolt = voltsum / p;

	for (s = 0; s<n; s++){
		currentsum += current[s];
	}
	avgcurrent = currentsum / s;

	for (r = 0; r<n; r++)
	{
		powersum += power[r];
	}
	averagepower = powersum / r;

	fprintf(outputFile, "	R(Ohms)	 V (Volts)\n");

	for (t = 0; t<n; t++)
	{
		fprintf(outputFile, "RV pair	%d: %.2lf	%.2lf\n", t, res[t], voltage[t]);
	}

	fprintf(outputFile, "\n\n	Voltage (V)	Current (A)	  Power (W)\n");    // Output file printing
	fprintf(outputFile, "MIN: %.2lf		  %.4lf	  %.4lf\n", minvolt, mincurrent, minimumpower);
	fprintf(outputFile, "MAX: %.2lf		  %.4lf	  %.4lf\n", maxvolt, maxcurrent, maxpower);
	fprintf(outputFile, "AVG: %.2lf		  %.4lf	  %.4lf\n", avgvolt, avgcurrent, averagepower);
}
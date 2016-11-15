/*********************/
/* Trever Wagenhals  */
/* Prog2_circuit     */
/* 2/1/2015          */
/*********************/

/****************************************************************************************************/	
/* This program will ask the user to define an input voltage and the resistance of three resistors  */
/* and generate current and voltage measurements through the resistors through a circuit with the   */
/* resistors in series, resistors in parallel, and a combination of series and parallel resistors.  */
/****************************************************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

//main will perform all calculations and output all data mentioned in program summary.
int main()
{
	double voltage;									//voltage to scan in 
	double R1, R2, R3;								//resistances to scan in
	double series_current;							//total current across series circuit
	double parallel_current;						//total current across parallel circuit
	double R1_voltage1, R2_voltage1, R3_voltage1;	//voltage across resistors in series circuit
	double R1_current2, R2_current2, R3_current2;	//current across resistors in parallel circuit
	double R1_current3, R2_current3, R3_current3;	//current across resistors in combined circuit
	double R23_combine;								//combine R2 + R3 in last circuit to make calculations easier
	double R1_voltage3;								//voltage across R1 in third circuit
	double R2_R3_voltage3;							//voltage across R2 + R3 in third circuit since they are equal
	
	//Asks user for voltage and resistance measurements
	printf("Enter Voltage Source Value (V): ");
	scanf("%lf", &voltage);
	printf("Enter three resistance values (ohms): ");
	scanf("%lf %lf %lf", &R1, &R2, &R3);

	series_current = voltage / (R1 + R2 + R3);		//Apply Ohms Law calculation to determine current	
	R1_voltage1 = R1*series_current;				//calculate the voltages
	R2_voltage1 = R2*series_current;				//at each resistor
	R3_voltage1 = R3*series_current;				//of series circuit

	//Prints current and voltage values of series circuit
	printf("\nSERIES CIRCUIT\n");
	printf("Current through circuit: %lf A \n", series_current);
	printf("Voltage across R1: %lf V \n", R1_voltage1);
	printf("Voltage across R2: %lf V \n", R2_voltage1);
	printf("Voltage across R3: %lf V \n", R3_voltage1);

	R1_current2 = voltage / R1;		//calculate the current
	R2_current2 = voltage / R2;		//at each resistor
	R3_current2 = voltage / R3;		//in parallel circuit

	//Prints current and voltage values of parallel circuit
	printf("\nPARALLEL CIRCUIT \n");
	printf("Voltage across each resistor: %lf V \n", voltage);
	printf("Current through R1: %lf A \n", R1_current2);
	printf("Current through R2: %lf A \n", R2_current2);
	printf("Current through R3: %lf A \n", R3_current2);

	R23_combine = (R2 * R3) / (R2 + R3);				//calculate total resistance across R2 and R3
	R1_current3 = voltage / (R23_combine + R1);			//calculate the current across R1
	R2_current3 = R1_current3 * (R3 / (R3 + R2));		//calculate the current across R2
	R3_current3 = R1_current3 * (R2 / (R2 + R3));		//calculate the current across R3
	R1_voltage3 = voltage * (R1 / (R1 + R23_combine));	//calculate voltage across R1
	R2_R3_voltage3 = voltage - R1_voltage3;				//calculate voltage across R1 + R2 since they are equal

	//Prints values of combination circuit
	printf("\nR2 & R3 IN PARALLEL \n");
	printf("Voltage across R1:  %lf V \n", R1_voltage3);
	printf("Current through R1: %lf A \n", R1_current3);
	printf("Voltage across R2:  %lf V \n", R2_R3_voltage3);
	printf("Current through R2: %lf A \n", R2_current3);
	printf("Voltage across R3:  %lf V \n", R2_R3_voltage3);
	printf("Current through R3: %lf A \n", R3_current3);
	return 0;
}
/*********************/
/* Trever Wagenhals  */
/* Prog9_Decode      */
/* 4/30/2015         */
/*********************/

/****************************************************************************************************/
/* This is a decoder for specific instructions to decide what operations should be performed and    */
/* displays results in output file                                                                  */
/****************************************************************************************************/

#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void main(){
	unsigned int inst;			// instruction for current
	int regs[32];				// file for register

	unsigned int dest;			// destination register number
	unsigned int opcode;		// Operation code
	unsigned int shamt;			// shift amount
	unsigned int src1, src2;    // first and second source operands register number

	char binaryfile[20];		//  name of binary file array
	char programfile[20];		//  name of program file array
	char outputfile[20];		//  name of output file array

	FILE *binarypointer;		// File pointer for binary file 
	FILE *filepointer;			// File pointer for program file 
	FILE *outputpointer;		// File pointer for output file.

	int i;						// loop iterations to read instruction.
	int temp;					// temporarily stores result before directly storing it in register file.

	printf("\nEnter register file name: ");
	scanf("%s", binaryfile);

	binarypointer = fopen(binaryfile, "r");
	fread(regs, sizeof(int), 32, binarypointer);
	if (binarypointer == NULL)
	{
		printf("Error: invalid file name %s\nProgram will now exit\n", binaryfile);
		printf("\nEnter register file name: ");
		scanf("%s", binaryfile);
	}


	printf("\nEnter program file name: ");
	scanf("%s", programfile);

	filepointer = fopen(programfile, "r");
	if (filepointer == NULL)
	{
		printf("Error: invalid file name %s\nProgram will now exit\n", programfile);
		printf("\nEnter program file name: ");
		scanf("%s", programfile);
	}


	printf("\nEnter program file name: ");
	scanf("%s", outputfile);

	outputpointer = fopen(outputfile, "w");
	while (outputpointer == NULL)
	{
		printf("Error: invalid file name %s\nProgram will now exit\n", outputfile);
		printf("\nEnter program file name: ");
		scanf("%s", outputfile);
	}

	// Reads instruction, decodes it, and performs operation. Following code scans in commands from 
	// program file into inst variable
	for (i = 0; ((fscanf(filepointer, "%x", &inst)) != EOF); i++)
	{

		// Decode instruction 
		opcode = (inst & 0xFC000000) >> 26;		// opcode = upper 6 bits (31-26)
		dest = (inst & 0x03E00000) >> 21;		// dest = bits (25-21)
		src1 = (inst & 0x001F0000) >> 16;		// src1 = bits (20-16)
		src2 = (inst & 0x0000F800) >> 11;		// src2 = bits (15-11)
		shamt = (inst & 0x000007C0) >> 6;		// Shift amount = bits (10-6)
		// Bits 5-0 are unused


		fprintf(outputpointer, "instRUCTION %d: 0x%.8x\n", i, inst);

		// Perform appropriate operation and store result
		if (opcode == 1)
		{
			temp = regs[src1] + regs[src2];
			fprintf(outputpointer, "R%d = R%d + R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d + %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		else if (opcode == 2)
		{
			temp = regs[src1] - regs[src2];
			fprintf(outputpointer, "R%d = R%d - R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d - %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		else if (opcode == 3)
		{
			temp = regs[src1] * regs[src2];
			fprintf(outputpointer, "R%d = R%d * R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d * %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		else if (opcode == 4)
		{
			temp = regs[src1] / regs[src2];
			fprintf(outputpointer, "R%d = R%d / R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d / %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		else if (opcode == 5)
		{
			temp = regs[src1] << shamt;
			fprintf(outputpointer, "R%d = R%d << R%d\n", dest, src1, shamt);
			fprintf(outputpointer, "    = %d << %d = %d\n\n", regs[src1], shamt, temp);
		}

		else if (opcode == 6)
		{
			temp = regs[src1] >> shamt;
			fprintf(outputpointer, "R%d = R%d >> R%d\n", dest, src1, shamt);
			fprintf(outputpointer, "    = %d >> %d = %d\n\n", regs[src1], shamt, temp);
		}

		else if (opcode == 7)
		{
			temp = regs[src1] & regs[src2];
			fprintf(outputpointer, "R%d = R%d & R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d & %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		else if (opcode == 8)
		{
			temp = regs[src1] | regs[src2];
			fprintf(outputpointer, "R%d = R%d | R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d | %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		else if (opcode == 9)
		{
			temp = regs[src1] ^ regs[src2];
			fprintf(outputpointer, "R%d = R%d ^ R%d\n", dest, src1, src2);
			fprintf(outputpointer, "    = %d ^ %d = %d\n\n", regs[src1], regs[src2], temp);
		}

		regs[dest] = temp;
	}

	fclose(binarypointer);
	fclose(filepointer);
	fclose(outputpointer);
}
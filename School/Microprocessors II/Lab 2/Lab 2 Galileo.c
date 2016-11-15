/*************************/
/* INCLUDED HEADER FILES */
/*************************/
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

/*******************************************/
/* DEFINE CERTAIN NUMBERS AS WORDS TO MAKE */
/* FOLLOWING THE CODE EASIER               */
/*******************************************/
#define uint 					unsigned int
#define Strobe 	   			    (34)					// GPIO13, physical IO pin 2
#define GP_3       				(16) 					// GPIO14, physical IO pin 3
#define GP_4       				(36) 					// GPIO6, physical IO pin 4
#define GP_5       				(18)  					// GPIO0, physical IO pin 5
#define GP_6       				(20) 	 				// GPIO1, physical IO pin 6
#define GPIO_DIRECTION_IN       (1)  
#define GPIO_DIRECTION_OUT      (0)
#define ERROR                   (-1)
#define SYNC 					(100000)
#define Strobe_2 	   			(13)					// GPIO13, physical IO pin 2
#define Strobe_3				(61)
#define GP_3_2       			(14) 					// GPIO14, physical IO pin 3
#define GP_4_2       			(6) 					// GPIO6, physical IO pin 4
#define GP_5_2       			(0)  					// GPIO0, physical IO pin 5
#define GP_6_2       			(1) 	 				// GPIO1, physical IO pin 6
#define MSG_GET					(2)
#define MSG_ACK					(14)
#define MSG_PING				(1)
#define MSG_RESET				(0)

/**************/
/* PROTOTYPES */
/**************/
void acknowledge();
void assignFileHandleInput();
void assignFileHandleOutput();
void closeAll();
int closeGPIO(int gpio, int fileHandle);
int openFileForReading(int gpio);
int errorCheckFileHandle(int fileHandle);
int openGPIO(int gpio, int direction);
void openStrobe();
int readGPIO(int fileHandle, int gpio);
void strobeLowHigh();
int writeGPIO(int fHandle, int val);
void writePingToGPIO();
void writeReceiveADC();
void writeResetToGPIO();
void closeStrobe();

/********************/
/* GLOBAL VARIABLES */
/********************/
int fileHandleGPIO_3 = 0; //declare an integer that represents the value of physical IO pin 3 for error checking
int fileHandleGPIO_4 = 0; //declare an integer that represents the value of physical IO pin 4 for error checking
int fileHandleGPIO_5 = 0; //declare an integer that represents the value of physical IO pin 5 for error checking
int fileHandleGPIO_6 = 0; //declare an integer that represents the value of physical IO pin 6 for error checking
int fileHandleGPIO_S = 0; //declare an integer that represents the value of physical IO pin 2 for error checking
int fileHandleGPIO_3_2 = 0; //declare an integer that represents the value of physical IO pin 3 for error checking
int fileHandleGPIO_4_2 = 0; //declare an integer that represents the value of physical IO pin 4 for error checking
int fileHandleGPIO_5_2 = 0; //declare an integer that represents the value of physical IO pin 5 for error checking
int fileHandleGPIO_6_2 = 0; //declare an integer that represents the value of physical IO pin 6 for error checking
int fileHandleGPIO_S_2 = 0; //declare an integer that represents the value of physical IO pin 2 for error checking
int fileHandleGPIO_S_3 = 0;
uint ADC, ADC1, ADC2, ADC3, ADC4, ADC5, ADC6, ADC7, ADC8, ADC9, ADC10, ACK; 		  //placeholders for each bit that is received
int userinput = 0;

void main()
{
	openStrobe();				
	assignFileHandleOutput(); 									//initiate all GPIO pins as Outputs.
        while(1)
        {		
			while(1)
			{
				printf("Type 0 to reset sensor, 1 to ping, 2 to receive ADC value, and 3 to quit the program: ");
				scanf("%i", &userinput);
						
				switch(userinput) {
					case MSG_PING: 		
						closeAll();
						assignFileHandleOutput();						//PING CASE
						writePingToGPIO(); 						//WRITES THE CORRECT VALUES TO EACH GPIO PIN FOR PING CASE
						closeAll();
						assignFileHandleInput();
						acknowledge();
						closeAll();
						assignFileHandleOutput();
						break;
					case MSG_GET: 									//RETRIEVE ADC CASE
						writeReceiveADC();//WRITES THE CORRECT VALUES TO EACH GPIO PIN FOR RECEIVE ADC CASE (INCLUDES CHANGING GPIO PINS TO INPUT)
						
						printf("The decimal value of ADC is %u \n", ADC);
						printf("The binary value of ADC is %u%u%u%u%u%u%u%u%u%u \n", ADC10, ADC9, ADC8, ADC7, ADC6, ADC5, ADC4, ADC3, ADC2, ADC1);
						printf("The hexadecimal value of ADC is %X \n", ADC);
						break;
					case 3:
						closeAll();
						closeStrobe();
						exit(0);	
					case MSG_RESET: 									//RESET CASE
						writeResetToGPIO(); 					//WRITES THE CORRECT VALUES TO EACH GPIO PIN FOR RESET CASE
						closeAll();
						assignFileHandleInput();
						acknowledge();
						closeAll();
						assignFileHandleOutput();
						break;							//EXIT THE PROGRAM
					default:
						printf("Your entry is not a valid option! Try again \n");					
				}
			}
        }
}

/******************************************************/
/* EVERY FUNCTION THAT IS USED, IN ALPHABETICAL ORDER */
/******************************************************/

/************************************************************************************/
/* ACKNOWLEDGE FUNCTION TO SET GPIO DIRECTIONS WHEN WAITING FOR ACKNOWLEDGED SIGNAL */
/************************************************************************************/
void acknowledge()
{
	strobeLowHigh();
	
	ACK = readGPIO(fileHandleGPIO_6_2, GP_6_2);  		/*************************************************************/
	ACK = (ACK<<1) + readGPIO(fileHandleGPIO_5_2, GP_5_2);  /*	read in the 4 bits saying that represent acknowledge */
	ACK = (ACK<<1) + readGPIO(fileHandleGPIO_4_2, GP_4_2);  /*                                                           */
	ACK = (ACK<<1) + readGPIO(fileHandleGPIO_3_2, GP_3_2);  /*************************************************************/		
	strobeLowHigh();
						
	if (ACK == MSG_ACK)
		printf("ACKNOWLEDGED! \n");
}

/********************************************/
/* SET ALL THE GPIO PINS TO INPUT DIRECTION */ 
/********************************************/
void assignFileHandleInput()
{	
	fileHandleGPIO_3 = openGPIO(GP_3, GPIO_DIRECTION_IN);   
	errorCheckFileHandle(fileHandleGPIO_3);

	fileHandleGPIO_4 = openGPIO(GP_4, GPIO_DIRECTION_IN);    
	errorCheckFileHandle(fileHandleGPIO_4);
	
	fileHandleGPIO_5 = openGPIO(GP_5, GPIO_DIRECTION_IN);   
	errorCheckFileHandle(fileHandleGPIO_5);
	
	fileHandleGPIO_6 = openGPIO(GP_6, GPIO_DIRECTION_IN);   
	errorCheckFileHandle(fileHandleGPIO_6);

	fileHandleGPIO_3_2 = openGPIO(GP_3_2, GPIO_DIRECTION_IN);   
	errorCheckFileHandle(fileHandleGPIO_3_2);

	fileHandleGPIO_4_2 = openGPIO(GP_4_2, GPIO_DIRECTION_IN);    
	errorCheckFileHandle(fileHandleGPIO_4_2);
	
	fileHandleGPIO_5_2 = openGPIO(GP_5_2, GPIO_DIRECTION_IN);   
	errorCheckFileHandle(fileHandleGPIO_5_2);
	
	fileHandleGPIO_6_2 = openGPIO(GP_6_2, GPIO_DIRECTION_IN);   
	errorCheckFileHandle(fileHandleGPIO_6_2);
}

/*****************************************/
/* SET ALL GPIO PINS TO OUTPUT DIRECTION */
/*****************************************/
void assignFileHandleOutput()
{	
	fileHandleGPIO_3 = openGPIO(GP_3, GPIO_DIRECTION_OUT);  
	errorCheckFileHandle(fileHandleGPIO_3);
	
	fileHandleGPIO_4 = openGPIO(GP_4, GPIO_DIRECTION_OUT);   
	errorCheckFileHandle(fileHandleGPIO_4);
	
	fileHandleGPIO_5 = openGPIO(GP_5, GPIO_DIRECTION_OUT);   
	errorCheckFileHandle(fileHandleGPIO_5);
	
	fileHandleGPIO_6 = openGPIO(GP_6, GPIO_DIRECTION_OUT);  
	errorCheckFileHandle(fileHandleGPIO_6);

	fileHandleGPIO_3_2 = openGPIO(GP_3_2, GPIO_DIRECTION_OUT);  
	errorCheckFileHandle(fileHandleGPIO_3_2);
	
	fileHandleGPIO_4_2 = openGPIO(GP_4_2, GPIO_DIRECTION_OUT);   
	errorCheckFileHandle(fileHandleGPIO_4_2);
	
	fileHandleGPIO_5_2 = openGPIO(GP_5_2, GPIO_DIRECTION_OUT);   
	errorCheckFileHandle(fileHandleGPIO_5_2);
	
	fileHandleGPIO_6_2 = openGPIO(GP_6_2, GPIO_DIRECTION_OUT);  
	errorCheckFileHandle(fileHandleGPIO_6_2);
}

/********************************************/
/* CLOSE ALL GPIOS WHEN EXITING THE PROGRAM */
/********************************************/
int closeGPIO(int gpio, int fileHandle)
{
    char buffer[256];
    close(fileHandle); //This is the file handle of opened GPIO for Read / Write earlier.
    fileHandle = open("/sys/class/gpio/unexport", O_WRONLY);
    if(ERROR == fileHandle)
    {
        puts("Unable to open file to shut off GPIO pin:");
        puts(buffer);
        return(-1);
    }
    sprintf(buffer, "%d", gpio);
    write(fileHandle, buffer, strlen(buffer));
    close(fileHandle);
    return(0);
}

/*******************************************************/
/* GENERIC CHECK TO VERIFY THAT THE GPIO FILES WERE    */
/* OPENED PROPERLY FOR DIRECTION STORING               */
/*******************************************************/
int errorCheckFileHandle(int fileHandle)
{
	if(ERROR ==  fileHandle)
    {
   		printf("Unable to open GPIO pin to set the direction properly. \n");
   		return(-1);
    }
}

/************************************************************/
/* WHILE GPIO PINS ARE SET AS INPUT, ALLOWS YOU TO TAKE THE */
/* VALUE READ FROM A CHOSEN GPIO AND SAVE IT TO AN INT                 */
/************************************************************/
int readGPIO(int fileHandle, int gpio)
{
        int value;
        //Reopening the file again in read mode, since data was not refreshing.
        fileHandle = openFileForReading(gpio);
        read(fileHandle, &value, 1);

        if('0' == value)
        {
             // Current GPIO status low
               value = 0;
        }
        else
        {
             // Current GPIO status high
               value = 1;
        }
        close(fileHandle);
        return value;
}

/*****************************************************/
/* ALTER STROBE BETWEEN LOW AND HIGH TO SIGNAL THAT  */
/* DATA HAS BEEN STORED AND IS READY TO RECEIVE MORE */
/*****************************************************/
void strobeLowHigh()
{
	writeGPIO(fileHandleGPIO_S_3, 0); //Signal that the bits have been saved and to start sending the next ones.
	usleep(SYNC); 
	writeGPIO(fileHandleGPIO_S_3, 1); //Strobe high and start collecting data
	usleep(SYNC);
}

/****************************************************/
/* REOPENS THE FILE WHEN YOU ARE READING DATA TO    */
/* ENSURE THAT THE VALUE IS CURRENT                 */
/****************************************************/
int openFileForReading(gpio)
{
    char buffer[256];
    int fileHandle;

    sprintf(buffer, "/sys/class/gpio/gpio%d/value", gpio);

    fileHandle = open(buffer, O_RDONLY);
    if(ERROR == fileHandle)
    {
	   puts("Unable to open file:");
	   puts(buffer);
	   return(-1);
    }
    return(fileHandle);  //This file handle will be used in read/write and close operations.
}

/***************************************************/
/* OPENS THE GPIO FILE OF CHOSEN GPIO TO ALLOW YOU */
/* TO DECLARE THE DIRECTION                        */
/***************************************************/
int openGPIO(int gpio, int direction )
{
    char buffer[256];
    int fileHandle;
    int fileMode;
		
    //Export GPIO
    fileHandle = open("/sys/class/gpio/export", O_WRONLY);
    if(ERROR == fileHandle)
    {
        puts("Error: Unable to open /sys/class/gpio/export");
        return(-1);
    }
    sprintf(buffer, "%d", gpio);
    write(fileHandle, buffer, strlen(buffer));
    close(fileHandle);
		
    //Direction GPIO
    sprintf(buffer, "/sys/class/gpio/gpio%d/direction", gpio);
    fileHandle = open(buffer, O_WRONLY);
    if(ERROR == fileHandle)
    {
        puts("Unable to open file:");
        puts(buffer);
        return(-1);
    }
    if (direction == GPIO_DIRECTION_OUT)
    {
        // Set out direction
        write(fileHandle, "out", 3);
        fileMode = O_WRONLY;
    }
    else
    {
        // Set in direction
        write(fileHandle, "in", 2);
        fileMode = O_RDONLY;
    }
    close(fileHandle);
    //Open GPIO for Read / Write
    sprintf(buffer, "/sys/class/gpio/gpio%d/value", gpio);
    fileHandle = open(buffer, fileMode);
    if(ERROR == fileHandle)
    {
        puts("Unable to open file:");

        puts(buffer);

        return(-1);
    }
    return(fileHandle);  //This file handle will be used in read/write and close operations.
}

/***********************************************************/
/* WHILE GPIO PINS ARE SET AS OUTPUT, ALLOWS YOU TO DEFINE */
/* WHETHER YOU WANT THE OUTPUT TO BE 1 OR 0                */
/***********************************************************/
int writeGPIO(int fHandle, int val)
{
	lseek(fHandle, 0, SEEK_SET);
        if(val ==  0)
        {
               // Set GPIO low status
               write(fHandle, "0", 1);
        }
        else
        {
               // Set GPIO high status
               write(fHandle, "1", 1);
		
        }
        return(0);
}

/************************************/
/* SENDS PROPER VALUES TO GPIO PINS */
/* FOR A PING COMMAND               */
/************************************/
void writePingToGPIO()
{
	writeGPIO(fileHandleGPIO_3_2, 1);
	writeGPIO(fileHandleGPIO_4_2, 0);
	writeGPIO(fileHandleGPIO_5_2, 0);
	writeGPIO(fileHandleGPIO_6_2, 0);
}

/************************************************************/
/* SENDS PROPER VALUES TO GPIO PINS FOR AN ADC COMMAND, AND */
/* THEN STARTS RECEVING THE ADC VALUES IN WAVES             */
/************************************************************/
void writeReceiveADC()
{
	writeGPIO(fileHandleGPIO_3_2, 0);
	writeGPIO(fileHandleGPIO_4_2, 1);
	writeGPIO(fileHandleGPIO_5_2, 0);
	writeGPIO(fileHandleGPIO_6_2, 0);	
	
	strobeLowHigh();
	
	assignFileHandleInput();				//TURN ALL THE GPIO PINS TO INPUT TO GET READY TO RECEIVE MESSAGE
						
	ADC1 = readGPIO(fileHandleGPIO_3_2, GP_3_2);
	ADC2 = readGPIO(fileHandleGPIO_4_2, GP_4_2);
	ADC3 = readGPIO(fileHandleGPIO_5_2, GP_5_2);
	ADC4 = readGPIO(fileHandleGPIO_6_2, GP_6_2);
						
	strobeLowHigh();
						
	ADC5 = readGPIO(fileHandleGPIO_3_2, GP_3_2); 
	ADC6 = readGPIO(fileHandleGPIO_4_2, GP_4_2);
	ADC7 = readGPIO(fileHandleGPIO_5_2, GP_5_2);
	ADC8 = readGPIO(fileHandleGPIO_6_2, GP_6_2);
					
	strobeLowHigh();
	
	ADC9 = readGPIO(fileHandleGPIO_3_2, GP_3_2); 
	ADC10 = readGPIO(fileHandleGPIO_4_2, GP_4_2);

	strobeLowHigh();

	acknowledge();

	strobeLowHigh();

	closeAll();
	assignFileHandleOutput();	

	ADC = ADC10;
	ADC = (ADC<<1) + ADC9;
	ADC = (ADC<<1) + ADC8;
	ADC = (ADC<<1) + ADC7;
						
	ADC = (ADC<<1) + ADC6;
	ADC = (ADC<<1) + ADC5;
	ADC = (ADC<<1) + ADC4;
	ADC = (ADC<<1) + ADC3;
										
	ADC = (ADC<<1) + ADC2; 
	ADC = (ADC<<1) + ADC1;
}

/******************************************/
/* SENDS PROPER VALUES TO GPIO PINS FOR	  */
/* THE PIC TO KNOW TO RESET ITS REGISTERS */	
/* TO ITS INTITAL STATES                  */
/******************************************/
void writeResetToGPIO()
{
	writeGPIO(fileHandleGPIO_3_2, 0); // call the write function we wrote to set the GPIO to write mode and send the data to the microcontroller
	writeGPIO(fileHandleGPIO_4_2, 0);
	writeGPIO(fileHandleGPIO_5_2, 0);
	writeGPIO(fileHandleGPIO_6_2, 0);
}

void openStrobe()
{
	fileHandleGPIO_S = openGPIO(Strobe, GPIO_DIRECTION_OUT); 	//ASSIGNS STROBE GPIO PIN AS AN OUTPUT AND SAVES THE RETURN VALUE FOR ERROR CHECKING
	errorCheckFileHandle(fileHandleGPIO_S);				//ERROR CHECKS VALUE STORED TO STROBE
	
	fileHandleGPIO_S_2 = openGPIO(Strobe_2, GPIO_DIRECTION_OUT); 	//ASSIGNS STROBE GPIO PIN AS AN OUTPUT AND SAVES THE RETURN VALUE FOR ERROR CHECKING
	errorCheckFileHandle(fileHandleGPIO_S_2);				//ERROR CHECKS VALUE STORED TO STROBE
	
	fileHandleGPIO_S_3 = openGPIO(Strobe_3, GPIO_DIRECTION_OUT); 	//ASSIGNS STROBE GPIO PIN AS AN OUTPUT AND SAVES THE RETURN VALUE FOR ERROR CHECKING
	errorCheckFileHandle(fileHandleGPIO_S_3);				//ERROR CHECKS VALUE STORED TO STROBE
	writeGPIO(fileHandleGPIO_S_3, 1);	
}

void closeAll()
{
	closeGPIO(GP_3, fileHandleGPIO_3);		//CLOSE ALL GPIO FILES, SHUTTING DOWN THE GPIO PINS
	closeGPIO(GP_4, fileHandleGPIO_4);
	closeGPIO(GP_5, fileHandleGPIO_5);
	closeGPIO(GP_6, fileHandleGPIO_6);
	closeGPIO(GP_3_2, fileHandleGPIO_3_2);		//CLOSE ALL GPIO FILES, SHUTTING DOWN THE GPIO PINS
	closeGPIO(GP_4_2, fileHandleGPIO_4_2);
	closeGPIO(GP_5_2, fileHandleGPIO_5_2);
	closeGPIO(GP_6_2, fileHandleGPIO_6_2);
}

void closeStrobe()
{
	closeGPIO(Strobe, fileHandleGPIO_S);
	closeGPIO(Strobe_2, fileHandleGPIO_S_2);
	closeGPIO(Strobe_3, fileHandleGPIO_S_3);
}

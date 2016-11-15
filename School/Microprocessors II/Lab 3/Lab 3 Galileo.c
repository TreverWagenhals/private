/*************************/
/* INCLUDED HEADER FILES */
/*************************/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <linux/i2c-dev.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <time.h>

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
#define GP_I2C                  (60) 
#define CHANGE_CLOCK			(4)
#define CLOSE_PROGRAM			(3)
#define SECONDS 			(0)
#define MINUTES 			(1)
#define HOURS				(2)
#define DAY_OF_WEEK			(3)
#define DAY_OF_MONTH			(4)
#define MONTH				(5)
#define YEAR				(6)

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
void read_the_time();
void read_the_clock(int DS1307_REGISTER);
void openI2C();
void change_the_time();


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
int file;

int change_time[6];
unsigned char temp_read[10];
char* days[] = {"", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
char* months[] = {"", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
unsigned char buf[10] = {0};

void main()
{
	openStrobe();	
	openI2C();			
	assignFileHandleOutput(); 									//initiate all GPIO pins as Outputs.
	read_the_time();
        while(1)
        {		
			while(1)
			{

				printf("Type 0 to reset sensor, 1 to ping, 2 to receive ADC value, 3 to quit the program, and 4 to update the time of the clock: ");
				scanf("%i", &userinput);
						
				switch(userinput) {
					case MSG_PING: 		
						writePingToGPIO(); 						//WRITES THE CORRECT VALUES TO EACH GPIO PIN FOR PING CASE
						closeAll();
						assignFileHandleInput();
						acknowledge();
						closeAll();
						assignFileHandleOutput();
						break;
					case MSG_GET: 									//RETRIEVE ADC CASE
						writeReceiveADC();//WRITES THE CORRECT VALUES TO EACH GPIO PIN FOR RECEIVE ADC CASE (INCLUDES CHANGING GPIO PINS TO INPUT)
						read_the_time();
						printf("The decimal value of ADC is %u \n", ADC);
						printf("The binary value of ADC is %u%u%u%u%u%u%u%u%u%u \n", ADC10, ADC9, ADC8, ADC7, ADC6, ADC5, ADC4, ADC3, ADC2, ADC1);
						printf("The hexadecimal value of ADC is %X \n", ADC);
						break;
					case CLOSE_PROGRAM:
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
					case CHANGE_CLOCK:
						change_the_time();
						break;
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

/*****************************/
/* OPENS THE GPIO FOR STROBE */
/*****************************/
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

/*************************************/
/* OPEN I2C GPIO AND I2C DEVICE FILE */
/*************************************/
void openI2C()
{
    int fileHandle_GPIO_68;                                                                                     
    fileHandle_GPIO_68 = openGPIO(GP_I2C, GPIO_DIRECTION_OUT);                                                                                          
    writeGPIO(fileHandle_GPIO_68, 0); 

	char *filename = "/dev/i2c-0";
	if((file = open(filename, O_RDWR)) < 0)
	{
		printf("Failed to open the i2c bus");
	}

	int addr = 0x68;          						// I2C Address of DS1307
	if (ioctl(file, I2C_SLAVE, addr) < 0) 
	{
    	printf("Failed to acquire bus access and/or talk to slave.\n");
	}
}

/*****************************************/
/* READS EACH REGISTER AND STORES RESULT */
/* TO ARRAY                              */
/*****************************************/
void read_the_clock(int DS1307_REGISTER)                                           
{                                                                       
    buf[0] = DS1307_REGISTER;        										// Register you want to point at                                                          

	if(write(file, buf, 1) != 1)                              	            // Point at proper register with write command
	{                                                                         
   		 printf("Failed to write to the i2c bus.\n");                  
	}                                                           
	
	if(read(file, buf, 1) != 1)  											// Now read the register we pointed to                                              
	{                                                                                                                                                                                                
    		printf("Failed to read from the i2c bus.\n");            
	}                                                                                                                                                                                                                                                
	else
	{
		temp_read[DS1307_REGISTER] = ((buf[0]/16*10) + (buf[0]%16));		// Save buf value to array and convert it from BCD to decimal
	}                                                                                                                                                                                                                            
}   

/****************************************/
/* ALLOWS YOU TO CUSTOMIZE HOW YOU WANT */
/* THE TIME PRINTED OUT                 */
/****************************************/
void read_the_time()
{
		int i;
		for (i = 0; i < 7; i++)
		{
			read_the_clock(i);
		}

		printf("%s, %s %i 20%i, %02i:%02i:%02i \n", days[temp_read[DAY_OF_WEEK]], months[temp_read[MONTH]], temp_read[DAY_OF_MONTH], temp_read[YEAR], temp_read[HOURS], temp_read[MINUTES], temp_read[SECONDS]); 
} 

/***********************/
/* ALLOWS TIME UPDATES */
/***********************/
void change_the_time()
{
		int accept;
		int days_in_that_month;
	
		printf("You are now going to change the time. For simplicity, seconds will be left out and just set to 0, so pick the time based on the next possible minute: \n\n");
				
		do
		{
		printf("What year is it, from 0-99? (Note: just choose the year in the century ie. 16 would be 2016) \n");
		scanf("%i", &change_time[YEAR]);
	
		if (change_time[YEAR] < 0 || change_time[YEAR] > 99)
			printf("Error: Year should be from 0-99 \n");
		}while (change_time[YEAR] < 0 || change_time[YEAR] > 99);
		

		do
		{
		printf("1  - January  2  - February  3 - March     \n");
		printf("4  - April    5  - May       6 - June      \n");
		printf("7  - July     8  - August    9 - September \n");
		printf("10 - October  11 - November  12 - December \n");
		printf("What month is it?: ");
		scanf("%i", &change_time[MONTH]);
		if (change_time[MONTH] < 1 || change_time[MONTH] > 12)																	// Only 12 months in a year
			printf("The number you chose does not represent a month... try again! \n");
		else if (change_time[MONTH] == 9 || change_time[MONTH] == 4 || change_time[MONTH] == 6 || change_time[MONTH] == 11)		// These months have 30 days
			days_in_that_month = 30;
		else if (change_time[MONTH] == 2 && (change_time[6] % 4) == 0)															// Leap year
			days_in_that_month = 29;
		else if (change_time[MONTH] == 2 && (change_time[6] % 4) != 0)															// February
			days_in_that_month = 28;
		else
			days_in_that_month = 31;																							// Rest have 31 days
		} while (change_time[MONTH] < 1 || change_time[MONTH] > 12);
		
		
		do
		{
		printf("What day of the month is it? ");
		printf("(Note: for the month of %s, ", months[change_time[MONTH]]);
		printf("there are only %i days): ", days_in_that_month);
		scanf("%i", &change_time[DAY_OF_MONTH]);
		if (change_time[DAY_OF_MONTH] < 1 || change_time[DAY_OF_MONTH] > days_in_that_month)				// Makes sure the user knows how many days are in the month they picked
			printf("Error: The month you chose cannot be represented with that date... try again! \n");
		}
		while (change_time[DAY_OF_MONTH] < 1 || change_time[DAY_OF_MONTH] > days_in_that_month);;
		
		do
		{
		printf("1 - Sunday \n2 - Monday\n3 - Tuesday \n4- Wednesday\n5 - Thursday \n6 - Friday \n7- Saturday \n");
		printf("What day of the week is it?: ");
		scanf("%i", &change_time[DAY_OF_WEEK]);
		if (change_time[DAY_OF_WEEK] < 1 || change_time[DAY_OF_WEEK] > 7)
			printf("Error: the number you chose does not represent a day of the week");		
		} while (change_time[DAY_OF_WEEK] < 1 || change_time[DAY_OF_WEEK] > 7);
			

		do
		{
		printf("What is the current hour? (Note: the hour system is set to 24-Mode, so choose the hour from 0-23): ");
		scanf("%i", &change_time[HOURS]);
		if (change_time[HOURS] < 0 || change_time[HOURS] > 23)
			printf("Error: The number you chose cannot be represented by hours... try again! \n");

		} while (change_time[HOURS] < 0 || change_time[HOURS] > 23);
		
		do
		{
		printf("What minute is it? (Note: pick the next possible minute on the clock, ranging from 0-59): ");
		scanf("%i", &change_time[MINUTES]);
		if (change_time[MINUTES] < 0 || change_time[MINUTES] > 59)
			printf("Error: The number you chose cannot be represented by minutes... try again! \n");

		} while (change_time[MINUTES] < 0 || change_time[MINUTES] > 59);
				
		printf("Is the time that you want to set the clock to %s, %s %i 20%i, %02i:%02i:00? \n", days[change_time[DAY_OF_WEEK]], months[change_time[MONTH]], change_time[DAY_OF_MONTH], change_time[6], change_time[HOURS], change_time[MINUTES]);

		do
		{
		printf("Press 1 to accept changes, and 2 to discard changes (NOTE: If you are accepting changes, wait until the time changes to the next minute to have the seconds accurate): ");
		scanf("%i", &accept);

		if (accept != 1 && accept != 2)
			printf("Error: choose one of the options given \n");
		} while (accept != 1 && accept != 2);

		if (accept == 1)
		{	
			int j;
			for (j = 0; j < 7; j++)
			{
				buf[j+1] = ((change_time[j]/10*16) + (change_time[j]%10));				// Save the values the user chose to buf starting at the second value
			}																			// since buf[0] is the array. Convert user's int choice to BCD

			buf[0] = 0x00;
			write(file, buf, 8);														// Writes the starting address, plus the 7 register values to the system
		}
		else
			printf("Time change ABORTED \n");
}
	

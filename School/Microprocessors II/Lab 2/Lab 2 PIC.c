/****************/
/* HEADER FILES */
/****************/
#include<xc.h>

/************************/
/* DEFINE ABBREVIATIONS */
/************************/
#define uchar unsigned char
#define uint unsigned int
#define MSG_GET		(0b0010)
#define MSG_ACK		(0b1110)
#define MSG_RESET	(0b0000)
#define MSG_PING	(0b0001)

/******************/
/* CONFIGURATIONS */
/******************/
#pragma config FOSC = INTOSCIO  // Oscillator Selection bits (INTOSCIO oscillator: I/O function on RA4/OSC2/CLKOUT pin, I/O function on RA5/OSC1/CLKIN)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = ON       // MCLR Pin Function Select bit (MCLR pin function is MCLR)
#pragma config CP = OFF         // Code Protection bit (Program memory code protection is disabled)
#pragma config CPD = OFF        // Data Code Protection bit (Data memory code protection is disabled)
#pragma config BOREN = ON       // Brown Out Detect (BOR enabled)
#pragma config IESO = ON        // Internal External Switchover bit (Internal External Switchover mode is enabled)
#pragma config FCMEN = ON       // Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)

/**************/
/* PROTOTYPES */
/**************/
void init();
void delay(uint x);
void LED(); 
uint first4;
uint second4;
uint last2;
void output();
void MSGACK();
int StrobeCheck();

/********/
/* MAIN */
/********/
void main()
{
    init(); 			//run initialize function
    while(1)			//loop
	{
        while(RA2 == 0) //Wait until Galileo has been turned on
        {;}
		StrobeCheck(); 	//check to see what the value of the strobe is and store current pin values of strobe when it changes
		output(); 	   	//receive the information and send the output based on what the information was
	}
}

/*****************************************/
/* ALL OF THE FUNCTIONS USED TO RUN MAIN */
/*****************************************/

/******************************************/
/* SET ALL THE REGISTERS TO CORRECT STATE */
/******************************************/
void init()				//initialize function
{
    CMCON0=0x07;		//set Comparator off
    TRISA=0X05;			//set RA0 and RA2(strobe) to input
    TRISC=0x0F;			//set RC0 output, set RC2 RC3 RC4 RC5 as input
    ANSEL=0x01;			//set AN0 analog
    PORTA=0;			//set port RA 0
    PORTC=0;			//set port RC 0
    ADCON0=0x81;		//set A/D Conversion Result Right justified,voltage reference 
				//from VDD to ground, select analog channel AN0,enable ADC 
    ADCON1=0x10;		//set Conversion Clock FOSC/8
}


/**************************************************/
/* CHECK TO SEE IF THE STROBE BIT HAS CHANGED AND */
/* IF SO, RETRIEVE THE VALUE OF THE OTHER 4 BITS  */
/**************************************************/
int StrobeCheck()
{ 
	uint reading;
	
	/********************************************************************/
	/* LOOP THAT CONSTANTLY CHECKS VALUE OF STROBE UNTIL CHANGE IN SEEN */
	/********************************************************************/
	while (RA2 == 1)
	{;}
		
		if (RA2 == 0) 					//Galileo is saying to read the command now
		{
			reading = PORTC;
		}

	return(reading); 						//return reading of pins to strobecheck
}


/************************************************/
/* SEND BACK DATA BASED ON THE COMMAND RECEIVED */
/************************************************/
void output()
{
	TRISC = 0x0; 							//turn RC2 RC3 RC4 and RC5 to output pins to get ready to send back data
    
	if (StrobeCheck() == MSG_ACK) 				//asking to send an acknowledge ping
	{
		MSGACK();
	}
	else if (StrobeCheck() == MSG_GET) 			//asking to send ADC value
	{
        GO = 1;
        while(GO);
   	
        while (RA2 == 0)
        {;}

        do
		{
			PORTC = ADRESL & 0x0F;
		} while (RA2 == 1);

        while (RA2 == 0)
        {;}
            
        do
        {
            PORTC = (ADRESL>>4) & 0x0F;
        } while (RA2 == 1);
        
        while (RA2 == 0)
        {;}
       
        do
        {
            PORTC = ADRESH & 0x03;
        } while (RA2 == 1);
        
        MSGACK();
        TRISC=0x0F;		
    }   	
	else if (StrobeCheck() == 0)  			//asking to reset PIC to initial state
	{
		MSGACK();
		init();							//reset pins back to initial state
	}
}

/*****************************************/
/* SEND THE ACKNLOWEDGE BITS TO THE PINS */
/*****************************************/
void MSGACK()
{
	do
	{
		PORTC = MSG_ACK;
	} while (RA2 == 1); 		    //make sure that the four bits are sent until the strobe toggles low to acknowledge it has received the message.
				//set RC2 RC3 RC4 RC5 back as inputs after the message has been sent and saved.
}
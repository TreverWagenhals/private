
#include<xc.h>
#define uchar unsigned char
#define uint unsigned int
// CONFIG
#pragma config FOSC = INTOSCIO  // Oscillator Selection bits (INTOSCIO oscillator: I/O function on RA4/OSC2/CLKOUT pin, I/O function on RA5/OSC1/CLKIN)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = ON       // MCLR Pin Function Select bit (MCLR pin function is MCLR)
#pragma config CP = OFF         // Code Protection bit (Program memory code protection is disabled)
#pragma config CPD = OFF        // Data Code Protection bit (Data memory code protection is disabled)
#pragma config BOREN = ON       // Brown Out Detect (BOR enabled)
#pragma config IESO = ON        // Internal External Switchover bit (Internal External Switchover mode is enabled)
#pragma config FCMEN = ON       // Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)

void init();
void delay(uint x);
void LED(); 
uint get_ad();

void main()
{
    init();
    while(1)
    LED();
}

void delay(uint x)
{
	uint a,b;
	for(a=x;a>0;a--)
		for(b=110;b>0;b--);
}

void init()
{
    CMCON0=0x07;
    TRISA=0X01;
    TRISC=0x00;
    ANSEL=0x01;
    PORTA=0;
    PORTC=0;
    ADCON0=0x81;
    ADCON1=0x10;
    delay(10);
    
}

uint get_ad()
{
    uint adval;
    GO=1;
    while(GO);
    adval=ADRESH;
    adval=adval<<8;
    adval=adval+=ADRESL;
    return (adval);
}

void LED()
{
    if (get_ad()<300)
    {
        RC0=1;
    }
    else
    {
        RC0=0;
    }
}
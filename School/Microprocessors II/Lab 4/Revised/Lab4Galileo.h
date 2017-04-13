#ifndef LAB4_H
#define LAB4_H

#include <string.h>

struct string 
{
  char *ptr;
  size_t len;
};

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
void *Time_and_ADC();
void HTTP_GET(const char* url);
void *Switch_statement(void *arg);
void *Server_function(void *arg);
void *User_choices(void *arg);
void *Standby_counter(void *arg);
size_t writefunc(void *ptr, size_t size, size_t nmemb, struct string *s);
void init_string(struct string *s);

#endif
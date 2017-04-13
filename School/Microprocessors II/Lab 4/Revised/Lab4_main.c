/*************************/
/* INCLUDED HEADER FILES */
/*************************/
#include <pthread.h>

/**************************************/
/* Create threads for different tasks */
/**************************************/
pthread_t SEND_TO_SERVER_THREAD;
pthread_t PIC_COMMUNICATION_THREAD;
pthread_t USER_INTERFACE_THREAD;
pthread_t STANDBY_THREAD;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t standby_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t CONDITION_UI = PTHREAD_COND_INITIALIZER;
pthread_cond_t CONDITION_PIC = PTHREAD_COND_INITIALIZER;
pthread_cond_t CONDITION_SERVER = PTHREAD_COND_INITIALIZER;

int main(int argc, char *argv[])
{
	openStrobe();	
	openI2C();			
	assignFileHandleOutput(); 									//initiate all GPIO pins as Outputs.
	read_the_time();	

	pthread_create(&USER_INTERFACE_THREAD, NULL, User_choices, NULL);	
	pthread_create(&PIC_COMMUNICATION_THREAD, NULL, Switch_statement, NULL);
	pthread_create(&SEND_TO_SERVER_THREAD, NULL, Server_function, NULL);
	pthread_create(&STANDBY_THREAD, NULL, Standby_counter, NULL);

	pthread_join(STANDBY_THREAD, NULL);
	pthread_join(USER_INTERFACE_THREAD, NULL);
	pthread_join(PIC_COMMUNICATION_THREAD, NULL);
	pthread_join(SEND_TO_SERVER_THREAD, NULL);
}

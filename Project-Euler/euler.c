#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>

int Project_1();
int Project_2();
int Project_3();
int Project_4();
int Project_5();
int Project_6();
int Project_7();
int Project_10();
int Project_14();

int main()
{
	clock_t begin = clock();

	Project_6();
	
	clock_t end = clock();
	double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
	printf("\nTime is %f seconds", time_spent);
	
	return 0;
}

/***********************************************************/
/* If we list all the natural numbers below 10 that are    */
/* multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of   */
/* these multiples is 23.                                  */
/* Find the sum of all the multiples of 3 or 5 below 1000. */
/***********************************************************/
int Project_1()			// COMPLETED SUN, 11 SEP 2016, 14:09 
{
	int total = 0;
	
	for (int i = 0; i < 1000; i++)
	{
		if ((i % 3 == 0) || (i % 5 == 0))
		{
			total += i;
		}
	}
	printf("Sum is %i", total);
}


/**********************************************************/
/* Each new term in the Fibonacci sequence is generated   */
/* by adding the previous two terms. By starting with 1   */
/* and 2, the first 10 terms will be:                     */
/* 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...                 */
/* By considering the terms in the Fibonacci sequence     */
/* whose values do not exceed four million, find the sum  */
/* of the even-valued terms.                              */
/**********************************************************/
int Project_2()			// COMPLETED SUN, 11 SEP 2016 14:41
{
	int sum = 0;
	int fib1 = 0;
	int fib2 = 1;
	int temp;
	
	for (int i = 1; i < 4000000; i = fib2)
	{
		if (i % 2 == 0)
		{
			sum += i;
		}
		
		temp = fib2;
		fib2 = fib1 + fib2;
		fib1 = temp;
		
	}
	printf("Sum is %i", sum);
}

/****************************************************************/
/* The prime factors of 13195 are 5, 7, 13 and 29.              */
/* What is the largest prime factor of the number 600851475143? */
/****************************************************************/
int Project_3()				// COMPLETED MON, 12 SEP 2016, 05:41
{	
	long long current = 600851475143; 
	int i = 2;
	int high = 0;

	while (1)
	{
		while (current % i == 0)
		{
			current = current / i;
			high = i; 
		}
	  
		if (current == 1)
			break;
	
		i++;
	}

	printf ("Highest prime factor of 600851475143 is %d\n", high);
}

/*****************************************************************************/
/* A palindromic number reads the same both ways. The largest palindrome     */
/* made from the product of two 2-digit numbers is 9009 = 91 × 99.           */
/* Find the largest palindrome made from the product of two 3-digit numbers. */
/*****************************************************************************/
int Project_4()							// COMPLETED MON, 12 SEP 2016, 02:44
{	
	int largest_palindrome = 0;
	for (int i = 100; i < 1000; i++)
	{
		for (int j = 100; j < 1000; j++)
		{	
			int n = j*i;
			int remainder;
			int reversed_int = 0;
			int original_int = n;
			
			while (n != 0)
			{
				remainder = n%10;
				reversed_int = reversed_int*10 + remainder;
				n /= 10;
			}
			if (original_int == reversed_int)
			{
				if (original_int > largest_palindrome)
					largest_palindrome = original_int;	
			}
		}
	}
	printf("Largest palindrome is: %i", largest_palindrome);
}

/******************************************************************/
/* 2520 is the smallest number that can be divided by each of the */
/* numbers from 1 to 10 without any remainder.                    */
/* What is the smallest positive number that is evenly divisible  */
/* by all of the numbers from 1 to 20?                            */
/******************************************************************/
int Project_5()
{
	int counter = 0;
	int number = 20;
	do
	{
		for (int i = 1; i < 21; i++)
		{
			if (number % i != 0)
				counter = 0;
			else
				counter++;
		}
		if (counter != 20)
			number++;
	} while (counter != 20);
	printf("%i is the first number divisible by 1-20", number);
}

/**************************************************************************/
/* The sum of the squares of the first ten natural numbers is,            */
/* 12 + 22 + ... + 102 = 385                                              */
/* The square of the sum of the first ten natural numbers is,             */
/* (1 + 2 + ... + 10)2 = 552 = 3025                                       */
/* Hence the difference between the sum of the squares of the first ten   */
/* natural numbers and the square of the sum is 3025 − 385 = 2640.        */
/* Find the difference between the sum of the squares of the first one    */
/* hundred natural numbers and the square of the sum.                     */
/**************************************************************************/
int Project_6()
{
	int sum_of_square = 0;
	int square_of_sum = 0;
	int sum = 0;
	int square;
	
	for (int i = 1; i <= 100; i++)
		sum += i;
	
	square_of_sum = sum*sum;
	printf("The Square of the sum is %i\n", square_of_sum);
	
	for (int j = 1; j <= 100; j++)
	{
		square = j*j;
		sum_of_square += square;
	}
	
	printf("The sum of the square is %i\n", sum_of_square);
	int difference;
	difference = square_of_sum - sum_of_square;
	printf("The difference between the two is: %i", difference);
}

/******************************************************************/
/* By listing the first six prime numbers:                        */
/* 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.   */
/* What is the 10 001st prime number?                             */
/******************************************************************/
int Project_7()
{
	int counter = 0;
	for (int j = 1; counter <= 10001; j++)
	{	
		int flag = 0;
		for(int i=2; i<=j/2; ++i)
		{
			if(j % i == 0)
			{
				flag = 1;
				break;
			}
		}
		if (flag == 0)
			counter++;
		
		if (flag==0 && counter == 10002)
			printf("%d is the 10001st prime number.\n",j);
	}
}

int Project_10()
{
	long long int two_mil_sum = 0;
	
	for (long long int j = 2; j < 2000000; j++)
	{	
		bool is_prime = true;
		
		for(long long int i= 2; i <= sqrt(j); i++)
		{
			if(j % i == 0)
			{
				is_prime = false;
				break;
			}
		}
		if (is_prime == true)
			two_mil_sum += j;
	}
	printf("The total is %lli", two_mil_sum);
}

int Project_14()
{
	long int chain = 0;
	int integer = 0;
	for(long long int i = 13; i < 1000000; i++)
	{
		long long int temp = i;
		int counter = 1;
		while (temp != 1)
		{
			if (temp % 2 == 0)
				temp /= 2;
			else
				temp = 3*temp + 1;
			
			counter++;
		}
		
		if (chain < counter)
		{
			chain = counter;
			integer = i;
		}
	}
	printf("The longest chain is %i at number %i \n", chain, integer);
}


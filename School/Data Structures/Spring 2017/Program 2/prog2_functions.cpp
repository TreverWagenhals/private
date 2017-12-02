#include <stdlib.h>
#include <time.h>
#include <iostream>

time_t t;

using namespace std;

int *create_array(int n)
{
    int *array;
    array = new int[n];
    return array;
}

int linear_search(int arr[], int n, int req)
{
    t = clock();
    
    // Search the same data multiple times because otherwise the clock() doesn't change and we can't determine the time it takes.
    // We are able to do up to 10^6 since that's what we need to multiply the clock by anyway to get micro seconds.
    // The more loops (closer to 10^6) the more accurate the time is. However, the test takes much longer.
    // By doing 10,000 loops and multiplying the time by 100, we get the correct micro seconds with fairly high accuracy and swiftness.
    for(int j = 0; j < 10000; j++)
    {
        for(int i = 0; i < n; i++)
        {
            if(arr[i] == req)
            {
                cout << "Number Found"; // It will never find a number based on program specs though!
            }
        }
    }
    
    double time = double(clock() - t) / (double) CLOCKS_PER_SEC;
    cout << "Time to linear search " << n << " element array: " << time*100 << " uS \n";
    
}

int binary_search(int arr[], int n, int req)
{
    int left = 0;
    int right = n-1;
    t = clock();
    
    // This program runs incredibly quick, so we run it 10^9 times to get a reading, then divide by 10^3 to get micro seconds.
    for(int i = 0; i < 1000000000; i++)
    {
        while (left <= right) 
        {
            int middle = (left + right) / 2;
            if (arr[middle] == req)
                cout << "Found \n";
            else if (arr[middle] > req)
                right = middle - 1;
            else
                left = middle + 1;
        }
    }
    cout.precision(3);
    double time = double(clock() - t) / (double) CLOCKS_PER_SEC;
    cout << "Time to binary search " << n << " element array: " << time / 1000 << " uS \n";
}

void selection_sort(int arr[], int n)
{
    t = clock();
    for(int i = 0; i < n; i++)
    {
        int smallest = i;
        
        for(int j = i+1; j < n; j++)
        {
            if(arr[j] < arr[smallest])
            {
                smallest = j;
            }
        }
        swap(arr[i], arr[smallest]);
    }
    cout << fixed;
    cout.precision(0);
    double time = double(clock() - t) / (double) CLOCKS_PER_SEC;
    cout << "Time to selection sort " << n << " element array: " << time*1000000 << " uS \n";
}

int RNG(int seed)
{
    if (seed == -1)
    {
        srand(time(NULL));
    }
    else
    {
        srand(seed);
    }
}



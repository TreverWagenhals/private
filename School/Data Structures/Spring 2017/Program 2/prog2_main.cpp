#include <iostream>
#include <algorithm>
#include "prog2_functions.h"
using namespace std;

int main()
{
    int sizes[3];
    int *arrays[3];
    int seed;
    
    cout << "Enter seed for RNG (-1 for truly random seed): ";
    cin >> seed;
    
    while(seed < -1 || !(cin))
    {
        cout << "ERROR: Seed must be positive number, or -1 for time based random generation. Try again: ";
        cin.clear();
        cin.ignore(10000,'\n');
        cin >> seed;
    }
    
    RNG(seed);
    
    cout << "Enter three array sizes: ";
    cin >> sizes[0] >> sizes[1] >> sizes[2];
    
    while(sizes[0] < 0 || sizes[1] < 0 || sizes[2] < 0 || !(cin))
    {
        cout << "ERROR: Array size must be greater than 0 and a valid number. Try again: ";
        cin.clear();
        cin.ignore(10000,'\n');
        cin >> sizes[0] >> sizes[1] >> sizes[2];
    }
    
    cout << "Creating arrays ... \n";
    for(int i = 0; i < 3; i++)
    {
        arrays[i] = create_array(sizes[i]);
        for(int k = 0; k < sizes[i]; k++)
            arrays[i][k] = rand();
    }
    
    cout << "Linear search test ... \n";
    for(int i = 0; i < 3; i++)
        linear_search(arrays[i], sizes[i], -1);

    cout << "\nSelection sort test ... \n";
    for(int i = 0; i < 3; i++)
        selection_sort(arrays[i], sizes[i]);
    
    cout << "\nBinary search test ... \n";
    for(int i =0; i < 3; i++)
        binary_search(arrays[i], sizes[i], -1);
        
    for(int i = 0; i < 3; i++)
         delete [] arrays[i];   
     
    return 0;
}
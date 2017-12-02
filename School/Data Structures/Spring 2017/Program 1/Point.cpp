#include "Point.h"
#include "Polygon.h"
#include <iostream>

using namespace std;
struct Point;
struct Polygon;

void printPoint(Point &pt)
{
    cout << "(" << pt.x << ", " << pt.y << ")";   
}

void readPoint(Point &pt)
{
    cout << "-- Enter x and y coordinates: ";
    while(!(cin >> pt.x >> pt.y))
    {
        cout << "ERROR: Enter numbers only. Try again: ";
        cin.clear();
        cin.ignore(10000,'\n');
    }
}
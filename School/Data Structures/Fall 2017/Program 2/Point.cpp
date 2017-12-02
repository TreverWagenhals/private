#include <cmath>
#include <iostream>
#include "Point.h"
using namespace std;

// Compute the length of a line connecting the two points "pt1" and "pt2"
double Length(Point pt1, Point pt2)
{
	double lineLength;
	
	// vector distance equation
	lineLength = sqrt(pow(pt2.x - pt1.x, 2) + pow(pt2.y - pt1.y,2));
	
	return lineLength;
}

// Read from the keyboard a pair of integers(x, y) giving the location of a point
void GetPoint(Point &pt)
{
	cout << "Enter next point: ";
	
	// if enter key pressed, mark as invalid
	if (cin.peek() == '\n')
		pt.defined = false;
	else
	{
		// get function grabs carriage return as soon as cin complete so its not in input stream
		(cin >> pt.x >> pt.y).get();
		if (!cin)	// if not a valid number input, mark as false
			pt.defined = false;
		else
			pt.defined = true;
	}
	return;
}

// Display the point "pt" on the screen in Cartesian form
void ShowPoint(Point pt)
{
	cout << "(" << pt.x << ", " << pt.y << ")\n";
}
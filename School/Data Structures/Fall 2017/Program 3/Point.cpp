#include <cmath>
#include <iostream>
#include <cassert>
#include "Point.h"

using namespace std;

// Compute the length of a line connecting the two points "pt1" and "pt2"
double Point::Length(Point pt2)
{
	// vector distance equation
	return sqrt(pow(pt2.x - x, 2) + pow(pt2.y - y,2));
}

// Read from the keyboard a pair of integers(x, y) giving the location of a point
void Point::Get(istream &is)
{	
	
	// if enter key pressed, mark as invalid
	if (is.peek() == '\n')
		defined = false;
	else
	{
		// get function grabs carriage return as soon as cin complete so its not in input stream
		(is >> x >> y).get();
		defined = true;
	}
	return;
}

// Display the point "pt" on the screen in Cartesian form
void Point::Show(ostream &os)
{
	assert(defined);
	os << "(" << x << ", " << y << ")" << endl;
}


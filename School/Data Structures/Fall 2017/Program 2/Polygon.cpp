#include <cmath>
#include <iostream>

#include "Point.h"
#include "Polygon.h"
using namespace std;

// Determine value of the circumference of the input polygon
double PolyCircumference(Polygon &thePoly)
{
	double circumference = 0;
	
	// add lengths of numSides - 1. The last side is the first point and the last point, 
	// which doesn't wrap nicely in for loop
	for (int i = 0; i < thePoly.numSides - 1; i++)
		circumference += Length(thePoly.v[i], thePoly.v[i+1]);
	
	// last side is added outside of for loop
	circumference += Length(thePoly.v[0], thePoly.v[thePoly.numSides-1]);
	
	return circumference;
}

// Determine value of the area of the input polygon, as well as subsequent triangles that make it.
// Area is a pointer to the array that these values are to be stored
void PolyArea(Polygon &thePoly, double *area)
{
	double a;
	double b;
	double c;
	double s;
	
	// area equation for a triangle of sides with known lengths
	for (int i = 1; i < thePoly.numSides-1; i++)
	{
		// two of the sides share the "origin" first point as their parameter
		a = Length(thePoly.v[0], thePoly.v[i]);		
		b = Length(thePoly.v[0], thePoly.v[i+1]);
		// the last side is the distance between the outer non "origin" sides
		c = Length(thePoly.v[i], thePoly.v[i+1]);	
		s = (a + b + c) / 2;
		// store area of each triangle in array starting at 2nd position to numSides - 1
		area[i] = sqrt(s*(s-a)*(s-b)*(s-c));		
		// first position contains sum of all triangles, ie total area of polygon
		area[0] += area[i];							
	}	
}
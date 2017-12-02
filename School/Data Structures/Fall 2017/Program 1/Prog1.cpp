/******************************/
/* TREVER WAGENHALS           */
/* PROG 1 - CONVEX POLYGONS   */
/* 9/18/2017                  */
/******************************/

/************************************************************************************/
/* DESCRIPTION:                                                                     */
/* A program to compute the circumference and area of an arbitrary convex polygon   */
/* with three or more sides.                                                        */
/************************************************************************************/

#include <iostream>
#include <cmath>

using namespace std;

const unsigned MaxSides = 10; // Max num of sides in a polygon
const unsigned MinSides = 3;  // Min num of sides needed for a polygon

// Represents the location of a point in Cartesian coordinates
struct Point
{
	double x;			// x coordinate of point
	double y;			// y coordinate of point
	bool defined;		// flag to define whether coordinate point is valid
};

// Represents a polygon defined by a list of vertex points
struct Polygon
{
	unsigned numSides;			// number of sides in the polygon
	Point 	 v[MaxSides];		// list of points defining polygon vertices
};

// PROTOTYPES
double Length(Point pt1, Point pt2);
void   GetPoint(Point &pt);
void   ShowPoint(Point pt);
double PolyCircumference(Polygon &thePoly);
void   PolyArea(Polygon &thePoly, double *area);

int main()
{
	Polygon poly;
	poly.numSides = 0;			   // initialize to 0 and increment when defined side is entered
	double area[MaxSides-1] = {0}; // array to hold (MaxSides - 2) triangle areas and the total 
								   // area, making it (MaxSides - 1)
	
	cout << "ENTER A POLYGON DEFINITION: \n\n";
	
	// loop to GetPoint up to MaxSides times. If an invalid point is entered, stop looping. 
	// increment number of sides on valid point 
	for (int i = 0; i < MaxSides; i++)
	{
		GetPoint(poly.v[i]);
		if (!poly.v[i].defined)
			break;
		else if (++poly.numSides == MaxSides)
			cout << "\n Polynomial Full" << endl;
	}
	
	// only show points, calculate circumference and calculate area if there are at least 3 points
	if (poly.numSides >= MinSides)
	{
		// show all the points that make up the polygon sides
		cout << "\nHere is the polygon definition: \n";
		for (int i = 0; i < poly.numSides; i++)
			ShowPoint(poly.v[i]);
		
		// print returned circumference value
		cout << "\nCircumference = " << PolyCircumference(poly) << endl;
				
		// calculate area of polygon and triangles that make it
		PolyArea(poly, area);
		
		//print total polygon area
		cout << "\nPolygon Area = " << area[0] << endl << endl;
		
		// print area of numSides - 2 triangles. Count starts at 1, 
		// so only increment to numSides - 1
		for (int i = 1; i < (poly.numSides - 1); i++)
			cout << "Triangle " << i << ": Area = " << area[i] << endl;
	}
	else
		cout << "ERROR: a polygon must have at least 3 sides" << endl;
	
	return 0;
}

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
	cin >> pt.x >> pt.y;
	
	// if negative number or non-number key, mark as invalid
	if (!cin || pt.x < 0 || pt.y < 0)
		pt.defined = false;
	else
		pt.defined = true;
	
	return;
}

// Display the point "pt" on the screen in Cartesian form
void ShowPoint(Point pt)
{
	cout << "(" << pt.x << ", " << pt.y << ")\n";
}

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
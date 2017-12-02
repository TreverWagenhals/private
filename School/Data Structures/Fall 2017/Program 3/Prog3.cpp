/************************************************************************************/
/* TREVER WAGENHALS                                                                 */
/* PROG 3 - CONVEX POLYGONS AGAIN                                                   */
/* 10/06/2017                                                                       */
/************************************************************************************/
/* A program to compute the circumference and area of an arbitrary convex polygon   */
/* with three or more sides. This time, struct Point has been changed to a class    */
/************************************************************************************/

#include <iostream>
#include "Point.h"
#include "Polygon.h"
using namespace std;

void ShowPoly(Polygon &p)
{
   for (unsigned i = 0; i < p.numSides; i++)
   {
      Point nextPt = p.v[i];
      nextPt.Show(cout);
   }
}

int main()
{
	Polygon poly;
	poly.numSides = 0;		// initialize to 0 and increment when defined side is entered
	
	cout << "ENTER A POLYGON DEFINITION:" << endl << endl;
	
	// loop to GetPoint up to MaxSides times. If an invalid point is entered, stop looping. 
	// increment number of sides on valid point 
	for (int i = 0; i < MaxSides; i++)
	{
		poly.v[i].Get(cin);
		if (!poly.v[i].Defined())
			break;
		else if (++poly.numSides == MaxSides)
			cout << endl << "Polynomial Full" << endl;
	}
	
	// there are 2 less triangles than numSides
	// array to hold each triangle's area and the total area
	const unsigned numTriangles = poly.numSides - 2;
	double area[numTriangles+1] = {0}; 
	// only show points, calculate circumference and calculate area if there are at least 3 points
	if (poly.numSides >= MinSides)
	{
		// show all the points that make up the polygon sides
		cout << "Here is the polygon definition: " << endl;
		ShowPoly(poly);
		// print returned circumference value
		cout << endl << "Circumference = " << PolyCircumference(poly) << endl;
		// calculate area of polygon and triangles that make it
		PolyArea(poly, area);
		// print total polygon area
		cout << endl << "Polygon Area = " << area[0] << endl << endl;
		for (int i = 1; i <= numTriangles; ++i)
			cout << "Triangle " << i << ": Area = " << area[i] << endl;
	}
	else
		cout << "ERROR: a polygon must have at least 3 sides" << endl;
	
	return 0;
}
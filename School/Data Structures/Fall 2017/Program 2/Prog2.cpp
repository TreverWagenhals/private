/************************************/
/* TREVER WAGENHALS                 */
/* PROG 2 - CONVEX POLYGONS AGAIN   */
/* 9/25/2017                        */
/************************************/

/************************************************************************************/
/* DESCRIPTION:                                                                     */
/* A program to compute the circumference and area of an arbitrary convex polygon   */
/* with three or more sides. This time, negative vertices are allowed and point     */
/* entry is terminated when ENTER is pressed.										*/
/************************************************************************************/

#include <iostream>
#include "Point.h"
#include "Polygon.h"
using namespace std;

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
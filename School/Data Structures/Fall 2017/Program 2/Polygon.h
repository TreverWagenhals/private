#ifndef POLYGON_H
#define POLYGON_H

const unsigned MaxSides = 10; // Max num of sides in a polygon
const unsigned MinSides = 3;  // Min num of sides needed for a polygon


// Represents a polygon defined by a list of vertex points
struct Polygon
{
	unsigned numSides;			// number of sides in the polygon
	Point 	 v[MaxSides];		// list of points defining polygon vertices
};

// PROTOTYPES
double PolyCircumference(Polygon &thePoly);
void   PolyArea(Polygon &thePoly, double *area);

#endif
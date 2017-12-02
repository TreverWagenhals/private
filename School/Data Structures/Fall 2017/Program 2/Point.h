#ifndef POINT_H
#define POINT_H

// Represents the location of a point in Cartesian coordinates
struct Point
{
	double x;			// x coordinate of point
	double y;			// y coordinate of point
	bool defined;		// flag to define whether coordinate point is valid
};

// PROTOTYPES
double Length(Point pt1, Point pt2);
void   GetPoint(Point &pt);
void   ShowPoint(Point pt);

#endif
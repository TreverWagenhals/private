#ifndef POLYGON_H
#define POLYGON_H
#include <vector>
#include "Point.h"

struct Polygon
{
   int verts;
   std::vector<Point> vertices;
};

void printPoly(Polygon &pol);

void readPoly(Polygon &pol);

int testPoly(Polygon &pol, double &x, double &y);

#endif
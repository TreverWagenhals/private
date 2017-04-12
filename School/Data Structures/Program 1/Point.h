#ifndef POINT_H
#define POINT_H

struct Point 
{
   double x; // X coordinate
   double y; // Y coordinate
};

void printPoint(Point &pt);

void readPoint(Point &pt);

#endif
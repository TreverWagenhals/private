#ifndef POINT_H
#define POINT_H

#include <iostream>
using namespace std;

#include <cassert>

/*--------------- t y p e    P o i n t ---------------*/

class Point
{
public:

   // Constructors
   Point () : defined(false) { }                                           // Default constructor
   Point (double xVal, double yVal) : x(xVal), y(yVal), defined(true) { }  // Explicit constructor

   // Accessors
   double X() { assert(defined); return x; }
   double Y() { assert(defined); return y; }
   bool  Defined() { return defined; }

   // Mutators
   void Set(double xVal, double yVal);

   // Length of a line from the calling point to pt2
   double Length(Point pt2);

   //Input-Output
   void Get(istream &is=cin);
   void Show(ostream &os=cout);

private:
   double x;       // x coordinate
   double y;       // y coordinate
   bool   defined; // true if this point has been defined; otherwise false
};

#endif
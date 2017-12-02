#include <climits>
#include <cmath>
#include "Point.h"

void Point::Get(istream &is)
{
   // Check for empty input.
   if (is.peek() == '\n')
      // Empty, mark the point undefined.
      defined = false;
   else
      {
      // Not empty. Read the x and y components and mark defined.
      is >> x >> y;
      defined = true;
      }

   // Flush to beginning of next line.
   is.ignore(INT_MAX, '\n');
}

void Point::Show(ostream &os)
{
   // Make sure that the point exists.
   assert(defined);

   // Display the point.
   os << "(" << x << ", " << y << ")";
}

void Point::Set(double xVal, double yVal)
{
   x = xVal;
   y = yVal;

   defined = true;
}

double Point::Length(Point pt2)
{
   // x distance from start to end
   double dx = pt2.x - x;
   // y distance from start to end
   double dy = pt2.y - y;

   // Length of line.
   return sqrt(dx*dx + dy*dy);
}

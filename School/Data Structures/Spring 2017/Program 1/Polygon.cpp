#include <iostream>
#include "Polygon.h"

using namespace std;

void printPoly(Polygon &pol)
{
   cout << "Vertices: \n";
   
   // Go through each vertices for the polygon that was inputted by user
   for(int i = 0; i < pol.vertices.size(); i++)
   {
        // Only print 4 points to a line, and create a space if its the last point for the polygon
        if (((i+1) % 4 == 0) || (i == pol.vertices.size() - 1))
        {
            printPoint(pol.vertices[i]);
            cout << "\n";
        }
        // Not end of line or vertices, so add a comma for neatness
        else
        {
            printPoint(pol.vertices[i]);
            cout << ", ";
        }
   }
}

void readPoly(Polygon &pol)
{
      cout << "Enter number of vertices: ";
      cin >> pol.verts;
      
      while(pol.verts < 1 || pol.verts > 10)
      {
          cin.clear();
          cin.ignore(10000,'\n');
          cout << "ERROR: A polygon is only allowed 10 vertices by program spec, and input must be a valid positive number. Try Again: ";
          cin >> pol.verts;
      }
 
      for(int i = 0; i < pol.verts; i++)
      {
          pol.vertices.push_back(Point());
          cout << "Point " << i;
          readPoint(pol.vertices[i]);
      }      
}

/***************************************************/
/* USE THE WINDING NUMBER METHOD TO CHECK IF POINT */
/* IS INSIDE OR OUTSIDE POLYGON                    */
/***************************************************/
int testPoly(Polygon &pol, double &x, double &y)
{
    int count = 0;
    for(int i = 0; i < pol.vertices.size(); i++)
    {               
        // Check to see if infinite line to point crosses the two vertices
        if(pol.vertices[i].y <= y && pol.vertices[i+1].y > y)
        {
            // Dot product of the vectors to determine if its an upward edge or downward edge.
            if ((pol.vertices[i+1].x - pol.vertices[i].x) * (y - pol.vertices[i].y) - (x - pol.vertices[i].x) * (pol.vertices[i+1].y - pol.vertices[i].y) > 0)
            {
                ++count;    // upward edge
            }
        }
        else if (pol.vertices[i].y > y && pol.vertices[i+1].y <= y) 
        {
            if ((pol.vertices[i+1].x - pol.vertices[i].x) * (y - pol.vertices[i].y) - (x - pol.vertices[i].x) * (pol.vertices[i+1].y - pol.vertices[i].y) < 0)
            {
                --count;    // downward edge
            }
        }
    }
    
    if(count == 0)
    {
       return 0;    // 0 = outside
    } 
    else
    {
       return 1;    // Others = inside
    }
}
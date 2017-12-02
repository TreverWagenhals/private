#include <iostream>

#include "Point.h"
#include "Polygon.h"

#include <vector>

using namespace std;

int main() 
{
   vector<Polygon> poly;    // vectors are the easiest way to dynamically change an array size over time
   char command;
   double x;
   double y;
   int polygon_number;
   bool a_poly = false;
   
   while(1)
   {
      cout << "Enter command (A | P | T | X): ";
      cin >> command;
         
      while(command != 'A' && command != 'a' && command != 'P' && command != 'p' && command != 'T' && command != 't' && command != 'X' && command != 'x')
      {
         cout << "Improper command. Try again: \n";
         cout << "Enter command (A | P | T | X): ";
         cin >> command;
      }
      
      switch(command)
      {
         case 'A': case 'a':
            if(poly.size() < 20)
            {
                // Adding a polygon, so increase vector size by 1, then read in values of that new space from user
                poly.push_back(Polygon());
                readPoly(poly[poly.size()-1]);
                a_poly = true;
                break;
            }
            else
            {
                cout << "ERROR: Only 20 Polygons allowed by project spec. Please restart program to enter new ones. \n";
                break;
            }
            
         case 'P': case 'p':
            for (int i = 0; i < poly.size(); i++)
            {
                cout << "POLYGON " << i << ":\n";
                printPoly(poly[i]);
                cout << "\n";
            }
            break;
            
         case 'T': case 't':
            if(a_poly == true)
            {
                cout << "Point to test--Enter x and y coordinates: ";
                
                while(!(cin >> x >> y))
                {
                    cin.clear();
                    cin.ignore(10000,'\n');
                    cout << "ERROR: Invalid input. Try again: ";
                }
                
                cout << "Enter polygon number: ";
                cin >> polygon_number;
               
                while(polygon_number < 0 || polygon_number >= poly.size())
                {
                    cout << "ERROR: Polygon number not valid. Pick another: ";
                    cin.clear();
                    cin.ignore(10000,'\n');
                    cin >> polygon_number;
                }
                
                if (testPoly(poly[polygon_number], x, y))
                {
                    cout << "(" << x << ", " << y << ") is inside polygon " << polygon_number << "\n\n";
                }
                else
                {
                    cout << "(" << x << ", " << y << ") is outside polygon " << polygon_number << "\n\n";
                }
                
                break;
            }
            else
            {
                cout << "ERROR: No polygon has been created yet to run a test. \n";
                break;
            }
            
         case 'X': case 'x':
            return 0;
      }
   }  
}

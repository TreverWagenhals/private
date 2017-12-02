/*--------------- L i s t . h ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Department
      UMASS Lowell

PURPOSE
This header file is the interface to the module "List.cpp."

CHANGES
10-28-2017 gpc - Created for 16.322
*/

#ifndef LIST_H
#define LIST_H
#include <cassert>

#include "Point.h"

//---------- c l a s s L i s t ----------

typedef Point ListItem;                      // Make list item data type generic.
const unsigned MaxItems = 10;                // List capacity
class List
{
public:
   List() : size(0), current(0) { }          // Construct an Empty List.
   bool Empty( ) { return size == 0; }       // True if empty
   bool Full( ) { return size >= MaxItems; } // True if full
   bool AtEnd( ) { return current >= size; } // True at end
   void Rewind( ) { current = 0; }           // Reset the current entry to the beginning.
   void Skip( )                              // Advance to next entry
      {
      assert(!AtEnd());
      ++current;
      }
   ListItem CurrentEntry()                   // Access the current item
      {
      assert(!AtEnd());
      return list[current];
      }
   void Insert(const ListItem &newItem);      // Insert before current entry
   void Update(const ListItem &item)          // Update current entry
      {
      assert(!AtEnd());
      list[current] = item;
      }
   void Delete();                             // Delete current entry
private:
   unsigned size;	                            // Number of items in the list
   unsigned current;	                         // Index of the current item
   ListItem list[MaxItems];                   // The array of items
};

#endif
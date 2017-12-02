/*--------------- P o s i t i o n . c p p  ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Dept.
      UMASS Lowell

PURPOSE
This module defines operations on objects of class Position.

CHANGES
10-11-2017 gpc - Create for EECE.3220 class.
*/

#include <iostream>
#include <cassert>

using namespace std;

#include "Position.h"


/*----- P o s i t i o n : : o p e r a t o r + ( ) -----

PURPOSE
Add two positions by adding the row numbers and adding the
column numbers.

INPUT PARAMETERS
b  -- the second operand of "+"
*/

Position Position::operator+(const Position &b) const
{
   Position result;

   result.row = row + b.row;
   result.col = col + b.col;
   result.defined = true;

   return result;
}

/*----- P o s i t i o n : : o p e r a t o r + = ( ) -----

PURPOSE
Add position "b" to this position.

INPUT PARAMETERS
b  -- the second operand of "+="
*/

Position Position::operator+=(const Position &b)
{
   row = row + b.row;
   col = col + b.col;
   defined = true;

   return *this;
}

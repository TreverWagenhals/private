/*--------------- L i s t . c p p ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Department
      UMASS Lowell

PURPOSE
This is an array-based list module.

CHANGES
10-28-2017 gpc - Created for 16.322
*/
#include "List.h" 

/*--------------- I n s e r t ( ) ---------------

PURPOSE
Insert a new entry before the current entry

INPUT PARAMETERS
d  -- the data to insert into the list
*/
void List::Insert(const ListItem &d)
{
  assert (!Full());

  // Copy down entries after the current entry.
  if (!AtEnd())
    for (unsigned i=size-1;i>current;i--)
      list[i+1] = list[i];

  // Add the new entry.
  list[current] = d;

  // Update the size and the number of the current entry.
  size++;
  current++;
}

/*--------------- D e l e t e ( ) ---------------

PURPOSE
Delete the current entry from the list.
*/
void List::Delete(void)
{
  assert(!AtEnd());

  // Copy back all entries after the current entry.
  for (unsigned i=current+1;i<size;i++)
    list[i-1] = list[i];

  // Update the size.
  size--;
}


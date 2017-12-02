/************************/
/* TREVER WAGENHALS     */
/* PROGRAM 9            */
/* December 6, 2017     */
/************************/

#ifndef HEAP_H
#define HEAP_H

#include <iostream>
#include <climits>
#include <cassert>
#include "CursorCntl.h"
template <typename ElemData, unsigned Capacity>
class Heap
{
public:
	// Constructor
	Heap() : size(0), current(0) { }
	// Return the number of elements in the array.
	unsigned Size() { return size; }
	// Return true if the array is empty.
	bool Empty() { return size == 0; }
	// Return true if the array is full.
	bool Full() { return size >= Capacity; }
	// Insert a new element into the array properly stored in ascending order..
	void Insert(ElemData &data);
	// Perform Heap Sort to sort the array into ascending order.
	void Sort();
	// Call "BinSearch()" to search the sorted array for the entry "data". 
	// If found, make this the current entry and return true;
	// otherwise, return false.
	bool Search(ElemData &data);

	// Perform a binary search for "data". Search the index range from
	// "start" to "end". If the item is found, make it the current item and return true.
	// Otherwise, return false.
	bool BinSearch(unsigned start, unsigned end, ElemData &data);

	// Output the array to the stream "os".
	void Output(ostream &os);
	// Show the heap on the right side of the screen.
	void ShowTree() const;
	// Return the current entry.
	ElemData CurrentEntry() { return heap[current]; }
   // Update the current entry.
   void Update() { assert(current != 0); heap[current].Update(); }

	// Standard heap operations
	void PercolateUp();
	void DeleteMax();
	void PercolateDown(unsigned r, unsigned n);
	void Heapify();

private:
	unsigned size;				// The number of items in the heap
	unsigned current;			// The index of the entry found by the last search
	ElemData heap[Capacity+1];	// The heap array

	// Recursive function to show the tree graphics
	void RShowTree(unsigned r, int x, int y) const;
};



const unsigned XRoot = 40;        // Column number for root node

// Recursive function to display a tree on the right half of the screen
// using (crude) character graphics.
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::RShowTree(unsigned r, int x, int y) const
{
  const unsigned VertSpacing = 7;   // Vertical spacing constant
  const unsigned HorizSpacing = 10; // Horizontal spacing of tree nodes
  const unsigned MaxLevels = 4;     // The number of levels that fit on the screen

  // If the tree is not empty display it..
  if (r <= size && x < MaxLevels)
    {
    // Show the left sub-tree.
    RShowTree(2*r, x+1, y+VertSpacing/(1<<x));
    // Show the root.
    gotoxy(XRoot+HorizSpacing*x, y);

	ElemData wc = heap[r];

	wc.Show(cout);

    // Show the right subtree.
    RShowTree(2*r+1, x+1, y-VertSpacing/(1<<x));
    }
}

// Display a tree on the right half of the screen using (crude)
// character graphics. This function calls RShowTree() which does
// the work.
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::ShowTree() const
{
  const unsigned YRoot = 12;      // Line number of root node
  const unsigned ScrollsAt = 24;  // Screen scrolls after line 24

#if (defined _WIN32) && (!defined NoGraphics)

  int xOld;                       // Old cursor x coordinate
  int yOld;                       // Old cursor y coordinate

  // Save cursor position
  getxy(xOld, yOld);

  // Has the screen scrolled yet?
  int deltaY = 0;

  if (yOld > ScrollsAt)
    deltaY = yOld - ScrollsAt+1;

  // Clear the right half of the screen.
  for (int y=0; y<ScrollsAt+1; y++)
  {
    gotoxy(XRoot,y+deltaY);
    clreol();
  }
  // Show the tree and offset if scrolled.
  RShowTree(1, 0, YRoot+deltaY);   

  // Restore old cursor position.
  gotoxy(xOld,yOld);      
#endif
}

// Sort array into heap
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::Sort()
{
	unsigned n = size;
	Heapify();
	
	while (n != 0)
	{
		swap(heap[1], heap[n]);
		PercolateDown(1, --n);
	}
	
}

// Go through entire heap and show data
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::Output(ostream &os)
{
	for (unsigned i = 1; i <= size; i++)
	{
		heap[i].Show(os);
		cout << endl;
	}
}

// Convert binary tree to a heap
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::Heapify()
{
	// start with last leaf node and percolate down
	// precede on non-leaf node until root is reached
	for (unsigned r = size/2; r >= 1; r--)
		PercolateDown(r, size);
}

// Delete last item
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::DeleteMax()
{
	// Move last item to root and then percolate
	heap[1] = heap[size--];
	PercolateDown(1, size);
}

// Move child up tree if greater than parent
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::PercolateUp()
{
	unsigned loc = size;
	unsigned parent = loc / 2;
	// Keep moving child if greater than parent
	while (parent >= 1 && heap[loc] > heap[parent])
	{
		swap(heap[loc], heap[parent]);
		loc = parent;
		parent = loc / 2;
	}
}


// Insert item in heap at correct location
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::Insert(ElemData &data)
{
	// increment count, store new item at end of heap, then
	// percolate up to find its true location
	size++;
	heap[size] = data;
	PercolateUp();
}

// Binary Search for data
template <typename ElemData, unsigned Capacity>
bool Heap<ElemData, Capacity>::BinSearch(unsigned start, unsigned end, ElemData &data)
{
	// Keep searching while there is still something between start and end
	while (start <= end)
	{
		// check middle, if equal to data, return true, otherwise
		// increment/decrement start/end appropriately and try again
		unsigned middle = (start + end) / 2;
		if (heap[middle] == data)
		{
			current = middle;
			return true;
		}
		else if (heap[middle] > data)
			end = middle - 1;
		else
			start = middle + 1;
	}
	return false;
}

// Move item down tree if smaller than child
template <typename ElemData, unsigned Capacity>
void Heap<ElemData, Capacity>::PercolateDown(unsigned r, unsigned n)
{
	unsigned c = 2*r;
	while (c <= n)
	{
		if (c < n && heap[c] < heap[c+1])
			c++;
		if (heap[r] < heap[c])
		{
			swap(heap[r], heap[c]);
			r = c;
			c *= 2;
		}
		else
			break;
	}
}

// Call BinSearch
template <typename ElemData, unsigned Capacity>
bool Heap<ElemData, Capacity>::Search(ElemData &data)
{
	return BinSearch(1, size, data);
}

#endif
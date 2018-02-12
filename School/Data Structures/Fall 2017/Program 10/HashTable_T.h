// Trever Wagenhals
// Program 10

#ifndef HASH_TABLE
#define HASH_TABLE

#include <iostream>
#include <iomanip>

using namespace std;

#include "CursorCntl.h"
#include "LinkedList_T.h"

template <typename ItemData, unsigned NumBuckets>
class HashTable
{
public:
   // Constructor: Make all buckets empty.
   HashTable() : size(0), curBucket(0) {}

   // Search the table for entry "d." If "d" is found, return true,make "d" 
   // the current entry for this bucket, and make this the current bucket.
   // If "d" is not found, return false.
   bool Search(ItemData &d);
   // Add an entry to the table.
   void Insert(ItemData &d);
   // Update an entry in the table.
   void Update(ItemData &d)
   {
      unsigned index = Hash(d);	// Compute bucket index.
      bucket[index].Update(d);	// Update the current entry in this bucket.
   }

   void Delete();    // Delete the current entry.
   // Return true if the table is empty.
   bool Empty() { return size == 0; }
   // Return the number of entries in the table.
   unsigned Size() { return size; }
   // Return the current entry.
   ItemData CurrentEntry() { return bucket[curBucket].CurrentEntry(); }
   // Remove the first entry from the table.
   ItemData Remove();
   // Show the hash table on the right side of the screen.
   void Show();
private:
   unsigned size;       // The number of entries in the table.
   unsigned curBucket;  // The index of the current bucket
   LinkedList<ItemData> bucket[NumBuckets]; // Array of pointers to linked lists
   unsigned long Hash(ItemData &d);     	// The hashing function
};

// Obtain a hash key from the ItemData object "d" and then generate
// a random table index such that 0 <= index <= Num Buckets-1.
template <typename ItemData, unsigned NumBuckets>
unsigned long HashTable<ItemData, NumBuckets>::Hash(ItemData &d)
{
   unsigned x = d.HashKey();    // Ask ItemData "d" for its hash key.
   
   // Now, generate a random table index such that 0 <= index <= NumBuckets-1
   const unsigned C1 = 25173;
   const unsigned C2 = 13849;
   const unsigned C3 = 65536;
   return ((C1*x + C2) % C3) % NumBuckets;
}
// Display a the hash table on the right half of the screen.
template <typename ItemData, unsigned NumBuckets>
void HashTable<ItemData, NumBuckets>::Show()
{
#if !NoGraphics
	const unsigned XLeft = 40;          // Column number for start of dictionary display
	const unsigned XHeading = XLeft - 3;// Column location of heading
	const unsigned ScrollsAt = 24;      // Screen scrolls after line 24
	const unsigned XMax = 79;           // Don't show words after this column
	const unsigned YSpacing = NumBuckets < 22 ? 22 / NumBuckets : 1;  // Vertical spacing
	const unsigned DisplayLines = NumBuckets < 22 ? NumBuckets : 22;// Number of buckets to display

	int xOld;                       // Old cursor position x coordinate
	int yOld;                       // Old cursor position y coordinate

									// Save cursor position
	getxy(xOld, yOld);

	// Has the screen scrolled yet?
	int deltaY = 0;

	if (yOld > ScrollsAt)
		deltaY = yOld - ScrollsAt + 1;

	// Clear the right half of the screen.
	for (int y = 0; y<ScrollsAt + 1; y++)
	{
		gotoxy(XLeft, y + deltaY);
		clreol();
	}

	// Display heading.
	gotoxy(XHeading, deltaY);
	cout << "BUCKET";

	// Show the array and offset if scrolled.
	for (unsigned index = 0; index<DisplayLines; index++)
	{
		// Display the bucket number.
		gotoxy(XLeft, YSpacing*index + deltaY + 2);
		cout << setw(2) << right << index << ": ";

		// Traverse the linked list bucket,
		// displaying each entry.
		bucket[index].Rewind();
		while (!bucket[index].AtEnd())
		{
			int xCursor;  // cursor x position
			int yCursor;  // cursor y position

			// Don't go off the right side of the screen
			getxy(xCursor, yCursor);
			if (xCursor + bucket[index].CurrentEntry().Word().length() >= XMax)
				break;

			// Display the next entry from the bucket. 
			cout << left;
			bucket[index].CurrentEntry().Show();
         cout << " ";
			bucket[index].Skip();
		}
	}
	gotoxy(xOld, yOld); 	// Restore old cursor position.
#endif  
}

// Remove the first word from the first bucket with data
template <typename ItemData, unsigned NumBuckets>
ItemData HashTable<ItemData, NumBuckets>::Remove()
{
	// Loop through each bucket
	for (curBucket = 0; curBucket < NumBuckets; curBucket++)
	{
		if (!bucket[curBucket].Empty()) 	// If bucket isn't empty
		{
			bucket[curBucket].Rewind(); 	// Reset bucket
			ItemData temp = CurrentEntry();
			bucket[curBucket].Delete();     // Delete 1st bucket entry
			size--;
			return temp;
		}
	}
	return CurrentEntry(); // Should never occur, but removes warning messages
}

// Determine if the data's hashed bucket contains the data already
template <typename ItemData, unsigned NumBuckets>
bool HashTable<ItemData, NumBuckets>::Search(ItemData &d)
{
	curBucket = Hash(d);
	if (!bucket[curBucket].Empty())	// Skip if bucket empty
	{
		bucket[curBucket].Rewind(); 		// Rewind to check all entries
		while (!bucket[curBucket].AtEnd()) 	// Check all entries
		{
			if (bucket[curBucket].CurrentEntry() == d)
				return true;
			else
				bucket[curBucket].Skip();
		}
	}
	return false;		
}

// Insert data into data's hashed bucket and increment size
template <typename ItemData, unsigned NumBuckets>
void HashTable<ItemData, NumBuckets>::Insert(ItemData &d)
{
	bucket[Hash(d)].Insert(d);
	size++;
}

// Remove current data from current bucket and decrement size
template <typename ItemData, unsigned NumBuckets>
void HashTable<ItemData, NumBuckets>::Delete()
{
	bucket[curBucket].Delete();
	size--;
}

#endif
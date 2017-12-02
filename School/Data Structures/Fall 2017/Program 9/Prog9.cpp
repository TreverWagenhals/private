/*--------------- P r o g 9 . c p p ---------------

by:   George Cheney
      EECE322 Data Structures
      ECE Department
      UMASS Lowell

PURPOSE
Count the number of occurrences of each word in a file

DEMONSTRATES
Heaps and Heap Sort

CHANGES
11-24-2017 gpc - Created for EECE322 
*/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>

using namespace std;

#include "CursorCntl.h"

#ifndef NoGraphics
#include <Windows.h>
#endif

#include "WordCount.h"
#include "Heap_T.h"

//----- c o n s t a n t    d e f i n i t i o n s -----

// Command Letters
const char AlphaCmd =      'A';  // Show the word list in alphabetical order.
const char ClearCmd =      'C';  // Erase the entire list.
const char DeleteCmd =     'D';  // Delete the maximum entry from the heap.
const char InsertCmd =     'I';  // Insert a new word into the word list
const char OpenCmd =       'O';  // Read in a word list from a file.
const char ShowHeapCmd =   'S';  // Show the heap on the right side of the screen as a tree.   
const char QuitCmd =       'Q';  // Quit

const unsigned MaxWords = 100;		// Heap capacity

//----- f u n c t i o n    p r o t o t y p e s -----

char GetCmd();
string GetFileName();
bool OpenFile(ifstream &stream);
void InsertWord(string word, Heap <WordCount, MaxWords>  &wordHeap);
void AddWord(Heap <WordCount, MaxWords>  &wordHeap);
void Delete(Heap <WordCount, MaxWords>  &wordHeap);
void ReadFile(Heap <WordCount, MaxWords>  &wordHeap);
string Capitalize(string word);

//--------------- m a i n ( ) ---------------

int main()
{
	Heap<WordCount, MaxWords>  wordHeap;	// The word heap
	char cmd;								// Command letter

	// Repeatedly get a command from the keyboard and
	// execute it.
	for (;;)
	{
		cmd = GetCmd();

		if (cmd != ' ')
		{
			// Determine which command to execute.
			switch (toupper(cmd))
			{
			case InsertCmd:      // Add a new word to the heap.
				AddWord(wordHeap);
				break;
			case DeleteCmd:     // Delete the current entry.
				Delete(wordHeap);
				break;
			case ClearCmd:		// Erase the entire heap.
				while (!wordHeap.Empty())
					Delete(wordHeap);
				break;
			case AlphaCmd:       // Show the word heap on the display in order.
				wordHeap.Sort();
				wordHeap.Output(cout);
				wordHeap.Heapify();
				break;
			case OpenCmd:       // Read in a file.
				ReadFile(wordHeap);
				break;
#if !defined(NoGraphics) 
         case ShowHeapCmd:
		      wordHeap.ShowTree();
            break;
#endif
			case QuitCmd:       // Terminate execution.
				return 0;
			default:            // Bad command
				cout << "*** Error: Unknown Command" << endl;
				break;
			}
		}
	}

	return 0;
}

/*--------------- C a p i t a l i z e ( ) ---------------

PURPOSE
Convert letters to lower case and delete non-alphabetic
characters from a string.

INPUT PARAMETERS
word  -- the word to uncapitialize
*/
string Capitalize(string word)
{
  string result = "";

  for(unsigned i=0; i<word.length(); ++i)
    if (isalpha(word[i]))
      result += toupper(word[i]);

  return result;
}

/*--------------- I n s e r t W o r d ( ) ---------------

PURPOSE
Insert a word into the word list.

INPUT PARAMETERS
word        --  the word to insert
wordHeap    --  the heap
*/
void InsertWord(string word, Heap <WordCount, MaxWords>  &wordHeap)
{
	// Check that the heap is not full.
	if (wordHeap.Full())
		{
		cout << "The list is full." << endl;
		return;
		}

	// Convert to lower case and make a WordCount object from the string word.
	WordCount wordCount(Capitalize(word));

	// If the word is already listed, increment the count; otherwise,
	// insert it into the list.
	wordHeap.Sort();
	if (wordHeap.Search(wordCount))
		{
		wordHeap.Update();
		wordHeap.Heapify();
		}
	else
		{
		wordHeap.Heapify();
		wordHeap.Insert(wordCount);
		}    
}

/*--------------- A d d W o r d ( ) ---------------

PURPOSE
Add a new word to the heap.

INPUT PARAMETERS
wordHeap    --  the heap
*/
void AddWord(Heap <WordCount, MaxWords>  &wordHeap)
{
  string word;                        // New word

  // Read the new word and insert it into the heap.
  cout << "Word: ";
  cin >> word;
  cin.ignore(INT_MAX, '\n');

  if (word.length() == 0)
	  return;
  
  InsertWord(word, wordHeap);
}

/*--------------- D e l e t e ( ) ---------------

PURPOSE
Delete the maximum entry from the heap.

INPUT PARAMETERS
wordHeap    --  the heap
*/
void Delete(Heap <WordCount, MaxWords>  &wordHeap)
{
	// If the heap is not empty, delete the largest entry.
	if (wordHeap.Empty())
		{
		cout << "The list is empty." << endl;
    
		return;
		}
	wordHeap.DeleteMax();
}

/*--------------- R e a d F i l e ( ) ---------------

PURPOSE
Read in a text file, adding words to the heap.

INPUT PARAMETERS
wordHeap    --  the heap.
*/
void ReadFile(Heap <WordCount, MaxWords>  &wordHeap)
{
	ifstream wordStream;	// Word text file input stream

	// If the file exists, open it.
	if (!OpenFile(wordStream))
		return;

	// Read in the entire file and build
	// the heap.
	for (;;)
		{
		string word;	// Next word

		// If not at end of file, read the next word and add to the heap.
		wordStream >> word;

		if (wordStream.eof())
			break;
      
		InsertWord(word, wordHeap);      
		}

	// Done, close the file.
	wordStream.close();
}


/*--------------- G e t C m d ( ) ---------------

PURPOSE
Accept a command from the keyboard.

RETURN VALUE
The command letter
*/
char GetCmd()
{
  char cmd;		// The command letter

  // Prompt for a new command.
  cout << ">";

  // If empty command, return space.
  if (cin.peek() == '\n')
	  cmd = ' ';
  else
	  // Read the command letter.
	  cmd = cin.get();

  // Flush rest of line.
  cin.ignore(INT_MAX, '\n');

  return cmd;
}

/*--------------- O p e n F i l e ( ) ---------------

PURPOSE
Associate an fstream with a file

OUTPUT PARAMETERS
stream  - the opened stream

RETURN VALUE
true if the file was opened successfully,
false otherwise
*/
bool OpenFile(ifstream &stream)
{
  string    fileName;    // The input file name

  // Ask for the file name and then open the file.
  fileName = GetFileName();
  if (fileName.length() == 0)
    return false;

  stream.open(fileName.c_str());

  // Verify that the file exists and was opened successfully.
  if (!stream.is_open())
    {
    cout << "*** ERROR: No such file " << fileName << endl;
    return false;
    }
    
  return true;
}

/*--------------- G e t F i l e N a m e ( ) ---------------

PURPOSE
Get a file name from the keyboard.

RETURN VALUE
the file name or empty string if none.
*/
string GetFileName()
{
  string        fileName;           // The file name

  // Prompt to enter a file name.
  cout << "File Name: ";
  cin >> fileName;

  // If empty, return an empty string.
  if (fileName.length() == 0)
    return "";

  // Add file extension ".txt" if missing.
  if (fileName.find(".") == string::npos)
	  fileName += ".txt";

  // Flush rest of line.
  cin.ignore(INT_MAX, '\n');

  return fileName;
}



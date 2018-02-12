/*--------------- P r o g 1 0 . c p p ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Department
      UMASS Lowell

PURPOSE
Count the number of occurrences of each word in a file

DEMONSTRATES
Hash Tables

CHANGES
11-27-2016 gpc - Created for 16.322
12-02-2016 gpc - Fix bug passing constant WordCount to reference parameter.
*/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>

#include <cassert>

using namespace std;

#include "WordCount.h"
#include "HashTable_T.h"
#include "BST_T.h"

// Define the number of buckets in the hash table.

#ifndef NumBucks
#define NumBucks 11 // Default number of buckets if not overridden externally
#endif

#if NumBucks < 1
#error Number of buckets must be a whole number no less than 1.
#endif

const unsigned NumBuckets = NumBucks;

// Command Letters
const char AlphaCmd =   'A';  // Show the word list in alphabetical order.
const char ClearCmd =   'C';  // Erase the entire list.
const char DeleteCmd =  'D';  // Delete a word from the hash table.
const char InsertCmd =  'I';  // Insert a new word into the word list
const char OpenCmd =    'O';  // Read in a word list from a file.
const char QuitCmd =    'Q';  // Quit
const char ShowCmd =    'S';  // Show the hash table on the screen.     

//----- f u n c t i o n    p r o t o t y p e s -----

char GetCmd();
string GetFileName();
bool OpenFile(ifstream &stream);
void InsertWord(string word, HashTable <WordCount, NumBuckets>  &wordTable);
void AddWord(HashTable <WordCount, NumBuckets>  &wordTable);
void DeleteWord(HashTable <WordCount, NumBuckets>  &wordTable);
void ReadFile(HashTable <WordCount, NumBuckets>  &wordTable);
void ShowTable(HashTable <WordCount, NumBuckets>  &wordTable);
string Capitalize(string word);

//--------------- m a i n ( ) ---------------

int main()
{
	HashTable<WordCount, NumBuckets>  wordTable; // The word hash table

	// Repeatedly get a command from the keyboard and
	// execute it.
	char cmd;	// Command letter

	do
	{
		cmd = GetCmd();

		if (cmd != ' ')
		{
			// Determine which command to execute.
			switch (toupper(cmd))
			{
			case InsertCmd:      // Add a new word to the hash table.
				AddWord(wordTable);
				break;
			case DeleteCmd:     // Delete a word from the hash table.
				DeleteWord(wordTable);
				break;
			case ClearCmd:		// Erase the entire table.
				while (!wordTable.Empty())
					wordTable.Remove();
				break;
			case AlphaCmd:       // Show the word table on the display in alphabetical order.
				ShowTable(wordTable);
				break;
			case OpenCmd:       // Read in a file.
				ReadFile(wordTable);
				break;
			case QuitCmd:       // Terminate execution.
				break;
#ifndef NoGraphics
         case ShowCmd:
		      wordTable.Show();
            break;
#endif
			default:            // Bad command
				cout << "*** Error: Unknown Command" << endl;
				break;
			}
		}
	} while (toupper(cmd) != QuitCmd);

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
wordTable   --  the hash table
*/
void InsertWord(string word, HashTable <WordCount, NumBuckets>  &wordTable)
{
  // Force lower case.
  WordCount wc(Capitalize(word));
  
  // If the word is already listed, increment the count; otherwise,
  // insert it into the list.
  if (wordTable.Search(wc))
    {
    wc = wordTable.CurrentEntry();
    wc.Update();
    wordTable.Update(wc);
    }
  else
    wordTable.Insert(wc);
}

/*--------------- A d d W o r d ( ) ---------------

PURPOSE
Add a new word to the hash table.

INPUT PARAMETERS
wordTable   --  the hash table
*/
void AddWord(HashTable <WordCount, NumBuckets>  &wordTable)
{
  string word;                        // New word

  // Ask for a word from the keyboard. 
  cout << "Word: ";

  // If empty word, do nothing.
  if (cin.peek() == '\n')
	  return;

  // Read in the word and add it to the table.
  cin >> word;
  cin.ignore(INT_MAX, '\n');

  InsertWord(word, wordTable);
}

/*--------------- D e l e t e W o r d ( ) ---------------

PURPOSE
Delete the current node from the current bucket from the hash table.

INPUT PARAMETERS
wordTable   --  the hash table
*/
void DeleteWord(HashTable <WordCount, NumBuckets>  &wordTable)
{
	// If the table is empty, say so.
	if (wordTable.Size() == 0)
		{
		cout << "The list is empty." << endl;
		return;
		}
    
	// Read in a word from the keyboard.
	string word;                        // Word to delete

	cout << "Word: ";
	// If empty just return.
	if (cin.peek() == '\n')
		return;

	cin >> word;
	// Flush rest of line.
	cin.ignore(INT_MAX, '\n');

	// If the word is in the table, delete it. Otherwise, report missing word.
	WordCount wc(Capitalize(word));
	if (wordTable.Search(wc))
		wordTable.Delete();
	else
		cout << "\"" << word << "\"" << " is not in the table." << endl;
}

/*--------------- R e a d F i l e ( ) ---------------

PURPOSE
Read in a text file, adding words to the hash table.

INPUT PARAMETERS
wordTable   --  the hash table.
*/
void ReadFile(HashTable <WordCount, NumBuckets>  &wordTable)
{
  ifstream  wordStream;  // The input stream

  if (!OpenFile(wordStream))
    return;

  // Read in the entire file and build
  // the hash table.
  for (;;)
    {
    string word;

    wordStream >> word;

    if (wordStream.eof())
      break;
      
    InsertWord(word, wordTable);      
    }

  wordStream.close();
}

/*--------------- G e t C m d ( ) ---------------

PURPOSE
Accept a command from the keyboard.

INPUT PARAMETERS
wordTable -- the word hash table.

RETURN VALUE
The command letter
*/
char GetCmd()
{
	char cmd;		// The command letter

	// Prompt for a new command.
	cout << ">";

	// Read the command leter. If empty return a space.
	if (cin.peek() == '\n')
		cmd = ' ';
	else
		cmd = cin.get();

	// Flush rest of line.
	cin.ignore(INT_MAX, '\n');

	return cmd;
}

/*--------------- O p e n F i l e ( ) ---------------

PURPOSE
Associate an ifstream with a file

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

  // Open the file.
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
Get a file name from the command line.

RETURN VALUE
the file name or empty string if none.
*/
string GetFileName()
{
  string        fileName;           // The file name

  // Ask for the file name from the keyboard.
  cout << "File Name: ";
  // If empty file name just return.
  if (cin.peek() == '\n')
	  return "";

  // Get the file name from the command line.
  cin >> fileName;
  // Flush the rest of the line.
  cin.ignore(INT_MAX, '\n');

  // If missing at ".txt" extension.
  if (fileName.find('.') == string::npos)
	  fileName += ".txt";

  return fileName;
}


/*--------------- S h o w T a b l e ( ) ---------------

PURPOSE
Show the word list in alphabetical order .

INPUT PARAMETERS
wordTable   -  the word hash table
*/
void ShowTable(HashTable <WordCount, NumBuckets>  &wordTable)
{
   // Remove one word at a time from the hash table and
   // insert the word into a BST.
   const unsigned HeapCapacity = 20;
   
   BST<WordCount>  wordTree;
   
   while (wordTable.Size() > 0)
      {
      WordCount   w = wordTable.Remove();
      
      wordTree.Insert(w);
      }
 
   // Dispaly the word list in order.  
   wordTree.OutputInOrder(cout);
 
   // Remove one word at a time from the heap and
   // insert the word into the hash table.
   while (!wordTree.Empty())
		{
		WordCount wc = wordTree.RemoveLeaf();
		wordTable.Insert(wc);
		}
}

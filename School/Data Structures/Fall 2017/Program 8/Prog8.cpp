/*--------------- P r o g 8 . c p p ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Department
      UMASS Lowell

PURPOSE
Count the number of occurrences of each word in a text file

DEMONSTRATES
Binary Search Trees
Class Templates

CHANGES
11-14-2017 gpc - Created for EECE.3220
*/
#include <iostream>
#include <fstream>
#include <string>
#include <cctype>

using namespace std;

#include "CursorCntl.h"

#ifndef NoGraphics
#include <Windows.h>
#endif

#include "WordCount.h"
#include "BST_T.h"

//----- c o n s t a n t    d e f i n i t i o n s -----

// Command Letters
const char ShowCmd =          'A';  // Show the tree inorder.
const char PreOrderCmd =      'B';  // Show the tree in preorder.
const char DeleteCmd =        'D';  // Delete the current entry from the tree.
const char InsertCmd =        'I';  // Add a new word to the tree.
const char ByLevelCmd =       'L';  // Show the tree level-by-level.
const char OpenCmd =          'O';  // Read in a tree from a file.
const char PostOrderCmd =     'P';  // Show the tree in postorder
const char QuitCmd =          'Q';  // Quit
const char ShowTreeCmd =      'S';  // Show the tree on the screen.

//----- f u n c t i o n    p r o t o t y p e s -----

char GetCmd();
string GetFileName();
bool OpenFile(ifstream &stream);
void AddWord(BST<WordCount> &wordTree);
void DeleteWord(BST<WordCount> &wordTree);
void ReadFile(BST<WordCount> &wordTree);
string Capitalize(string word);

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

/*--------------- A d d W o r d ( ) ---------------

PURPOSE
Add a new word to the tree.

INPUT PARAMETERS
wordTree    --  the tree
*/
void AddWord(BST<WordCount> &wordTree)
{
	string word;

	// Read in the new word and insert it into the tree.
	cout << "Word: ";
	cin >> word;

	cin.ignore(INT_MAX, '\n');

	if (word.length() > 0)
      {
      WordCount wordCount = WordCount(Capitalize(word));
		wordTree.Insert(wordCount);
      }
}

/*--------------- D e l e t e W o r d ( ) ---------------

PURPOSE
Delete the current node from the tree.

INPUT PARAMETERS
wordTree    --  the tree
*/
void DeleteWord(BST<WordCount> &wordTree)
{
  string word;           // Word to delete
      
  // Ask for the word.
  cout << "Word: ";
  cin >> word;

  // Flush rest of line.
  cin.ignore(INT_MAX, '\n');

  WordCount wordCount = WordCount(Capitalize(word));

  if (wordTree.Search(wordCount))
	// If the word is in the tree, delete it.
	wordTree.Delete();
  else
	// Say it's missing.
    cout << "\"" << word << "\"" << " is not in the tree." << endl;
}

/*--------------- R e a d F i l e ( ) ---------------

PURPOSE
Read in a text file, adding words to the tree.

INPUT PARAMETERS
wordTree    --  the tree.
*/
void ReadFile(BST<WordCount> &wordTree)
{
	ifstream wordStream;	// Filename input stream

	// Try to open the file.
	if (!OpenFile(wordStream))
		return;

	// Read in the entire file and build
	// the tree.
	while (wordStream.peek() != EOF)
		{
		string word;	// next word from file

		wordStream >> word;
		if (word.length() > 0)
         {
         WordCount wordCount = WordCount(Capitalize(word));
		   wordTree.Insert(wordCount);
         }
		}

	wordStream.close();
}


//--------------- m a i n ( ) ---------------

int main()
{
	BST<WordCount>  wordTree; // The word tree

	char cmdLetter; // The current command line

	// Repeatedly get a command from the keyboard and
	// execute it.
	do
	{
		cmdLetter = GetCmd();

		if (cmdLetter != ' ')
		{
			// Determine which command to execute.
			switch (toupper(cmdLetter))
			{
			case InsertCmd:      // Add a new word to the tree.
				AddWord(wordTree);
				break;
			case DeleteCmd:     // Delete the current entry.
				DeleteWord(wordTree);
				break;
			case ShowCmd:       // Show the word tree on the display inorder.
				wordTree.OutputInOrder(cout);
				break;
			case OpenCmd:       // Read in a file.
				ReadFile(wordTree);
				break;
			case QuitCmd:       // Terminate execution.
				break;
			case PreOrderCmd:   // Show the tree in preorder.
				wordTree.OutputPreOrder(cout);
				break;
			case PostOrderCmd:  // Show the tree in postorder.
				wordTree.OutputPostOrder(cout);
				break;
			case ByLevelCmd:    // Show the tree one level at a time.
				wordTree.OutputByLevel(cout);
				break;
#if !defined(NoGraphics) 
         case ShowTreeCmd:
		      wordTree.ShowTree();
            break;
#endif

			default:            // Bad command
				cout << "*** Error: Unknown Command" << endl;
				break;
			}
		}
	} while ((cmdLetter == ' ') || (toupper(cmdLetter) != QuitCmd));

	return 0;
}

/*--------------- G e t C m d ( ) ---------------

PURPOSE
Accept a command from the keyboard.

INPUT PARAMETERS
wordTree -- the alphabetized word tree.

RETURN VALUE
The command string
*/
char GetCmd()
{
  char cmdLetter;	// The command letter

  // Prompt for a new command.
  cout << ">";

  
  if (cin.peek() == '\n')
	// If empty command, return a space.
	cmdLetter = ' ';
  else
	// Read the command letter from the keyboard.
	cmdLetter = toupper(cin.get());

  // Flush rest of line.
  cin.ignore(INT_MAX, '\n');

  return cmdLetter;
}

/*--------------- O p e n F i l e ( ) ---------------

PURPOSE
Associate an ifstream with a file

INPUT PARAMETERS
mode    -- 'R' for reading, 'W' for writing

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

  // Append extension ".txt" if missing.
  if (fileName.find(".") == string::npos)
	  fileName += ".txt";

  // Open the file in read mode.
  stream.open(fileName.c_str(), fstream::in);

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
the file name or a space if none.
*/
string GetFileName()
{
  string        fileName;           // The file name

  // Prompt for the file name.
  cout << "File name: ";

  if (cin.peek() == '\n')
	// If empty, return an empty string.
	fileName = "";
  else
	// Get the file name from the command line.
	cin >> fileName;

  // Flush to end of line.
  cin.ignore(INT_MAX, '\n');
  return fileName;
}



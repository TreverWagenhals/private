#ifndef WORDCOUNT_H
#define WORDCOUNT_H
/*--------------- W o r d C o u n t . h ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Department
      UMASS Lowell

PURPOSE
Defines class WordCount to count the number of occurrences of words.

CHANGES
11-14-2017 gpc - Created for EECE.3220
*/

#include <iostream>
#include <string>

using namespace std;

//----- C l a s s    W o r d C o u n t -----

//Records one word and a count of the number of occurences of that word.

class WordCount
{
public:
   // Constructors
   WordCount() : word(""), count(0) { }
   WordCount(string theWord, unsigned theCount = 1) : word(theWord), count(theCount) { }

   // Accessors
   string Word() const { return word; }
   unsigned Count() const { return count; }
   
   // Mutator
   void Update() { ++count; }

   // Output a Word to a stream.
   void Show(ostream &os)  { os << word << "=" << count; }

   // Overloaded relational operators
	bool operator<(WordCount &rhs) { return word < rhs.word; }
	bool operator>(WordCount &rhs) { return word > rhs.word; }
	bool operator==(WordCount &rhs) { return word == rhs.word; }
	bool operator<=(WordCount &rhs) { return word <= rhs.word; }
	bool operator>=(WordCount &rhs) { return word >= rhs.word; }
	bool operator!=(WordCount &rhs) { return word != rhs.word; }

private:
   string   word;    // The word to be counted
   unsigned count;   // The number of occurrences
};
#endif
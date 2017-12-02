#ifndef MAZE_H
#define MAZE_H
/*--------------- M a z e . h ---------------

by:   George Cheney
      16.322 Data Structures
      ECE Dept.
      UMASS Lowell

PURPOSE
This is the interface to Maze.cpp.

CHANGES
10-11-2017 gpc - Create for EECE.3220 class.
*/


#include <fstream>
#include <string>

using namespace std;

#include "Position.h"
//#include "Stack.h"

//----- c o n s t a n t   d e f i n i t i o n s

const unsigned GridSize = 10;    // Number of rows and columns in the grid.

//----- t y p e    d e f i n i t  o n s -----

// Cell states are ASCII characters.
typedef char CellState;

// Define the possible states for cells in the grid.
const char Open      = ' ';
const char Obstacle  = '-';
const char Visited   = 'V';
const char Rejected  = 'R';
const char StartCell = 'S';
const char GoalCell  = 'G';
const char PathCell  = 'P';

//----- c l a s s    M a z e -----

class Maze
{
public:
   // Constructor
   Maze();
   
   // Accessors
   bool IsOpen(const Position &cellPos) const;  // true if "cellPos" is open

	Position Start() { return start; }  // Returns the start position

	Position Goal() { return goal; }    // Returns the goal position

   // Mutators
   void Visit(const Position &p);      // Mark position"p" visited.

   void Reject(const Position &p);     // Mark postion "p" rejected.

	void MarkPathCell(const Position &p);// Mark position "p" as a "path cell."
private:
   // The square grid of maze cells
   CellState	cell[GridSize][GridSize];

   // The starting position in the maze.
   Position    start;

   // The goal position in the maze.
   Position    goal;

   // Maze File Name
   string mazeFileName;

   // The number of moves per second
   int         speed;

   // Display the maze on the screen.   
   void Show() const;

   // Display the state of one cell on the screen.
   void ShowCell(const Position &p, const CellState state) const;

   // Load the maze definition from a file.
   void OpenMazeFile(string &mazeFileName, ifstream &mazeFile);
   void StoreCell(char c, int rowNum, int colNum);
   void LoadMazeFile();

   // Set the speed of travel.
   void SetSpeed();
};


#endif
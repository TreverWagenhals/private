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
10-22-2017 gpc - Create for EECE322 class.
*/


#include <fstream>
#include <string>

using namespace std;

#include "Position.h"
#include "Queue.h"

//----- c o n s t a n t   d e f i n i t i o n s

const unsigned GridSize = 10;    // Number of rows and columns in the grid.

//----- t y p e    d e f i n i t  o n s -----

// Cell states are integers.
typedef int CellState;

// Define the possible states for cells in the grid.
// Note that a non-negative cell state gives the distance of that cell
// from the start cell.

const int Open     = -1;	// Cell is open
const int Obstacle = -2;	// Cell is an obstacle
const int StartCell= -3;	// Cell is the start cell
const int GoalCell = -4;	// Cell is the goal cell
const int PathCell = -5;	// Cell is on the shortest path

//----- c l a s s    M a z e -----

class Maze
{
public:
   // Constructor
   Maze();
   
   // ACCESSORS

   // Return the distance of the cell at position "p" from the start.
   CellState State(const Position &p) const;

   // Return the start cell position.
   Position Start() const { return start; }

   // Return the goal cell position.
   Position Goal() const { return goal; }

   // MUTATOR

   // Mark the cell at position "p" with distance "dist".
   void Mark(const Position &p, const CellState dist);

private:
   // The square grid of maze cells
   CellState	cell[GridSize][GridSize];

   // The starting position in the maze.
   Position    start;

   // The goal position in the maze.
   Position    goal;

   // The number of moves per second
   int         speed;

   // Output stream for maze log file.
   ofstream logFile;

   // Display the maze on the screen.   
   void Show() const;

   // Show one cell on the screen.
   void ShowCellState(const Position &p, const CellState state) const;

   // Load the maze definition from a file.
   void OpenMazeFile(string &mazeFileName, ifstream &mazeFile);
   void StoreCell(char c, int rowNum, int colNum);
   void LoadMazeFile();

   // Set the speed of travel.
   void SetSpeed();
};


#endif
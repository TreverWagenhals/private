/*********************************************/
/* TREVER WAGENHALS                          */
/* PROGRAM 4 - FINDING A PATH THROUGH A MAZE */
/* 10/20/2017                                */
/************************************************************/
/* Given a maze program to read in maze files, a position   */
/* program to keep track of the position within the maze,   */
/* and a cursor program to output the maze, a singly linked */
/* list stack was designed to replace the array based stack */
/* that was given to navigate through a maze and backstep   */
/* at deadends until the goal is reached or all paths are   */
/* checked                                                  */
/************************************************************/

#include <stdlib.h>
#include <iostream>

using namespace std;

#include "CursorCntl.h"
#include "Maze.h"
#include "Stack.h"

// Push neighbor coordinate to stack and update maze
void updateMazeTraversal(Maze &maze, Stack &stack, Position direction)
{
	Position neighbor = stack.Top() + direction;
	stack.Push(neighbor);
	maze.Visit(stack.Top());
}
	
bool SolveMaze(Maze &maze, Stack &stack)
{
   // Make the start cell the current position.
   stack.Push(maze.Start());
   maze.Visit(stack.Top());
   // Repeatedly try to find a next move until the goal is reached.
   do
   {
      if (maze.IsOpen(stack.Top() + StepEast))
		updateMazeTraversal(maze, stack, StepEast);
      else if (maze.IsOpen(stack.Top() + StepSouth))
		updateMazeTraversal(maze, stack, StepSouth);
      else if (maze.IsOpen(stack.Top() + StepWest))
		updateMazeTraversal(maze, stack, StepWest);
      else if (maze.IsOpen(stack.Top() + StepNorth))
		updateMazeTraversal(maze, stack, StepNorth);
      else
	  {
		 maze.Reject(stack.Pop());
         if (stack.Empty())
			return false;
	  }
    } while (stack.Top() != maze.Goal());

   return true;    // Found a path.
}







int main(void)
{
	// Screen positions
	const unsigned XResult = 15;
	const unsigned YResult = 5;
	const unsigned XFinish = 0;
	const unsigned YFinish = 20;

	Stack posStack; // Position stack remembers visited positions. 
	Maze maze;		// Construct a maze from a maze definition file.
   
	// Traverse the maze.
	bool success = SolveMaze(maze, posStack);
	// Indicate success or failure.
	gotoxy(XResult, YResult);
	if (!success)
		cout << "Failed: No path from start to goal exists." << endl;
	else
	{
		cout << "Success: Found a path. Press ENTER to retrace..." << endl;
		cin.get();  // Wait for ENTER.
			
        // Retrace the path back to the goal.
		while (!posStack.Empty()) 
			maze.MarkPathCell(posStack.Pop());
	}
	gotoxy(XFinish, YFinish); 	// Done
	return 0;
}

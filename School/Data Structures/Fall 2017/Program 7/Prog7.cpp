/*********************************************/
/* TREVER WAGENHALS                          */
/* PROGRAM 7 - Recursive Maze Navigation     */
/* 11/15/2017                                */
/************************************************************/
/* Given a maze program to read in maze files, a position   */
/* program to keep track of the position within the maze,   */
/* and a cursor program to output the maze, a recursive     */
/* function was designed to navigate the maze               */
/************************************************************/

#include <stdlib.h>
#include <iostream>

using namespace std;

#include "CursorCntl.h"
#include "Maze.h"
	
// Marks position as path and returns true for recursive return
bool markPathReturnTrue(Maze &maze, Position &pos)
{
	maze.MarkPathCell(pos);
	return true;
}

// Function to recursively check cells and determine path through maze
bool PathFound(Maze &maze, Position pos)
{
	// Make sure the position being checked is open, otherwise return back
	// to previous recursive call
	if (!maze.IsOpen(pos))
		return false;
	
	// Mark as visited if open so that it is not visited twice
	maze.Visit(pos);
	
	// If the position is the goal, mark it as path and begin
	// recursive path recall. Wait until enter to retrace
	if (pos == maze.Goal())
	{
		cin.get();
		return markPathReturnTrue(maze, pos);
	}
	
	// Recursive call in each direction. If a neighbor returns
	// true as part of path, this position must also be part of
	// path and return true to previous recursive position
	if (PathFound(maze, pos + StepEast))
		return markPathReturnTrue(maze, pos);
	if (PathFound(maze, pos + StepSouth))
		return markPathReturnTrue(maze, pos);
	if (PathFound(maze, pos + StepWest))
		return markPathReturnTrue(maze, pos);
	if (PathFound(maze, pos + StepNorth))
		return markPathReturnTrue(maze, pos);
	
	// Reject position if not part of the path to goal
	maze.Reject(pos);
	return false;	
}




int main(void)
{
	// Screen positions
	const unsigned XResult = 15;
	const unsigned YResult = 5;
	const unsigned XFinish = 0;
	const unsigned YFinish = 20;

	Maze maze;		// Construct a maze from a maze definition file.
	
	// True if path found
	bool pathFound = PathFound(maze, maze.Start());
	gotoxy(XResult, YResult);

	if (pathFound)
		cout << "Success: Found a path." << endl;
	else
		cout << "Failed: No path from start to goal exists." << endl;

	gotoxy(XFinish, YFinish); 	// Done
	return 0;
}
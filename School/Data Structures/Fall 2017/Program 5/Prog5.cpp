/*****************************************/
/* TREVER WAGENHALS                      */
/* PROGRAM 5 - BREADTH FIRST SEARCH MAZE */
/* 11/01/2017                            */
/*****************************************/
/***************************************************************/
/* Use a singly linked list queue to do a breadth first search */
/* through a maze to find the shortest path to the goal        */
/***************************************************************/

#include <stdlib.h>
#include <iostream>

using namespace std;

#include "CursorCntl.h"
#include "Maze.h"

// Mark an open neighbor cell with distance + 1, check if neighbor is goal
// If neighbor is goal, return true, else add neighbor to queue and return false
bool goalReached(Maze &maze, Queue &queue, Position direction, unsigned &distance)
{
	maze.Mark(queue.Head() + direction, distance + 1);
	if (queue.Head() + direction == maze.Goal())
		return true;
	queue.Enqueue(queue.Head() + direction);
	return false;
}

// Keep track of path back to start and mark cells on the way back
void retraceMarker(Maze &maze, Position direction, Position &pos)
{
	pos += direction;
	maze.Mark(pos, PathCell);
}

bool Solve(Maze &maze, Queue &queue)
{
   // Move to the start cell.
   queue.Enqueue(maze.Start());
   maze.Mark(queue.Head(), 0);

    // Repeatedly try while the queue shows possibility for another move
    while (!queue.Empty())
	{
		// Get the current position's distance from the start position.
		unsigned distance = maze.State(queue.Head());

		// Find an open neighbor position, check if goal, and add to queue
		// break from function if goal has been reached by returning true
		if (maze.State(queue.Head() + StepEast) == Open)
			if (goalReached(maze, queue, StepEast, distance)) return true;
		if (maze.State(queue.Head() + StepSouth) == Open)
			if (goalReached(maze, queue, StepSouth, distance)) return true;
		if (maze.State(queue.Head() + StepWest) == Open)
			if (goalReached(maze, queue, StepWest, distance)) return true;
		if (maze.State(queue.Head() + StepNorth) == Open)
			if (goalReached(maze, queue, StepNorth, distance)) return true;
			
		// remove head after adding neighbors to queue
		queue.Dequeue();
	}
	
	return false;    // queue emptied without finding a solution
}
// Mark the path from the goal to the start cell.
void Retrace(Maze &maze)
{
	// grab distance and position of goal
	unsigned distance = maze.State(maze.Goal());
	Position pos      = maze.Goal();
	// mark goal as path
	maze.Mark(pos, PathCell);	
	do
	{
		// check each direction to see if its the appropriate step
		// back to start, marking it along the way
		if (maze.State(pos + StepNorth) == distance - 1)
			retraceMarker(maze, StepNorth, pos);
		else if (maze.State(pos + StepWest) == distance - 1)
			retraceMarker(maze, StepWest, pos);
		else if (maze.State(pos + StepSouth) == distance - 1)
			retraceMarker(maze, StepSouth, pos);
		else if (maze.State(pos + StepEast) == distance - 1)
			retraceMarker(maze, StepEast, pos);
			
		distance--; // decrement distance each step back until 0 (start)
	} while (pos != maze.Start()); // break when current position is start
}

int main()
{
	// Screen positions
	const unsigned XResult = 35;
	const unsigned YResult = 5;
	const unsigned XFinish = 0;
	const unsigned YFinish = 23;
       
	Maze  maze;				// Construct a maze from a maze definition file.
	Queue positionQueue;	// Create a queue of future positions to visit

	// Solve the maze.
	bool success = Solve(maze, positionQueue);

	// Indicate success or failure.
	gotoxy(XResult, YResult);
	if (!success)
		cout << "Failed: No path from start to goal exists." << endl;
	else
		{
		cout << "Success: Found the shortest path." << endl;
		gotoxy(XResult, YResult+2);
		cout << "Press ENTER to highlight the shortest path.";
		cin.get();
		// Retrace the path from the goal cell to the start cell.
		Retrace(maze);
		cout << endl;
		}
	// Done
	gotoxy(XFinish, YFinish);
	clreol();
	return 0;
}

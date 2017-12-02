#ifndef QUEUE_H
#define QUEUE_H

#include "Position.h"

typedef Position  QueueElem;  // The queue stores maze row/columns positions.

// Define a generic queue class.
class Queue
{
	// Node to hold Position data and point to next node in queue
	struct Node
	{
		QueueElem  data;
		Node      *next;
		
		Node() : next(NULL) {}
		Node(const QueueElem &theData) : data(theData), next(NULL) {}
	};
	
public:
   // Constructor: Create empty queue.   
   Queue() : head(NULL), tail(NULL) { }
   // Return true if queue empty.
   bool Empty() { return head == NULL; }
   // Enqueue a new entry to the tail.
   void Enqueue(const QueueElem &elem);
   // Dequeue the head entry.
   QueueElem Dequeue();
   // Retrieve the head entry.
   QueueElem Head();
private:
   Node *head;		         // Index of next element to remove
   Node *tail;		         // Index of space to add next element
};
#endif
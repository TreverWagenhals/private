#ifndef STACK_H
#define STACK_H

#include <cassert>
using namespace std;
#include "Position.h"

// Make the stack element type be a grid position.
typedef Position StackElement;

// Define a singly linked list based stack class.
class Stack
{
	struct Node
	{
		StackElement data;
		Node         *next;
		
		Node() {}
		Node(const StackElement &theData, Node *const theNext = 0)
			: data(theData), next(theNext) {}
	};
	
public:
   // Contruct an empty stack.
   Stack() {tos = NULL;}
   // Test for an empty stack.
   bool Empty() const { return tos == NULL; }
   // Push a new element onto the top of the stack.
   void Push(const StackElement &elem);
   // Retrieve the top element and pop it off of the stack.
   StackElement Pop();
   // Retrieve the top element, but do not remove it from the stack.
   StackElement Top() const;
private:
   Node   *tos;  // top node of the stack
};
#endif

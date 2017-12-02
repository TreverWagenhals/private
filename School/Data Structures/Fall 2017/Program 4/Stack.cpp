#include "stack.h"

// Push a new element onto the top of the stack.
void Stack::Push(const StackElement &elem)
{  
   Node* newNode = new Node;
   newNode->data = elem;
   newNode->next = tos;
   tos = newNode;
}

// Pop the top element off of the stack and return its value.
StackElement Stack::Pop()
{
   assert (!Empty());
   StackElement poppedData = tos->data;
   Node *temp = tos;
   tos = tos->next;
   delete temp;   
   return poppedData;
}

// Returns the value of the data on top of the stack
StackElement Stack::Top() const
{
   assert (!Empty());
   return tos->data;
}

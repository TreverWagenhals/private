#ifndef STACK_H
#define STACK_H

#include <string>

class Stack
{
	public:
		Stack();							// constructor
		~Stack();							// destructor
	
		void push(const std::string &val);	// push element val to stack
		void pop();							// remove top element from stack
		bool empty();						// check if the stack is empty
		
		
		std::string top();
		void show();
		friend std::ostream & operator<<(std::ostream &out, const Stack &s);
	
	private:
		struct node
		{
			std::string element;
			node* next;
		};
	
		node *first;
};

#endif

#ifndef STACK_H
#define STACK_H

#include <iostream>

template <class T>
class Stack
{
	public:
		Stack();							// constructor
		~Stack();							// destructor
	
		void push(const T &val);	// push element val to stack
		void pop();							// remove top element from stack
		bool empty();						// check if the stack is empty
		
		
		T top();
		
		friend std::ostream & operator<<(std::ostream &out, const Stack<T> &s)
		{
			if (s.first == NULL)
				out << "Stack is empty \n\n";
			else
			{
				out << "Stack : ";
				for(Stack<T>::node* n = s.first; n != NULL; n = n->next)
				{
					out << n->element << '\n' << "        ";
				}
				out << "\n";
			}
			return out;
		}
	
	private:
		struct node
		{
			T element;
			node* next;
		};
	
		node *first;
};

template <class T>
Stack<T>::Stack()
{
	first = NULL;
}

template <class T>
Stack<T>::~Stack()
{
	while (!empty())
		pop();
}

template <class T>
bool Stack<T>::empty()
{
	return (first == NULL);
}

template <class T>
void Stack<T>::push(const T &val)
{
	node *temp = new node;
	
	temp->element = val;
	temp->next = first;
	
	first = temp;
}

template <class T>
void Stack<T>::pop()
{
	node *temp = first;
	first = first->next;
	delete temp;
}

template <class T>
T Stack<T>::top()
{
	return first->element;
}

#endif

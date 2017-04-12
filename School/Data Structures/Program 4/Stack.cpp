#include "Stack.h"

#include <iostream>
#include <string>

using namespace std;

Stack::Stack()
{
	first = NULL;
}

Stack::~Stack()
{
	while (!empty())
		pop();
}

bool Stack::empty()
{
	return (first == NULL);
}

void Stack::push(const string &val)
{
	node *temp = new node;
	
	temp->element = val;
	temp->next = first;
	
	first = temp;
}

void Stack::pop()
{
	node *temp = first;
	first = first->next;
	delete temp;
}

ostream & operator<<(ostream &out, const Stack &s)
{
	if (s.first == NULL)
		out << "Stack is empty \n\n";
	else
	{
		out << "Stack : ";
		for(Stack::node* n = s.first; n != NULL; n = n->next)
		{
			out << n->element << '\n' << "        ";
		}
		out << "\n";
	}
	return out;
}

void Stack::show()
{
	struct node *show_ptr = first;
	
	if (show_ptr == NULL)
		cout << "Stack is empty\n";
	
	cout << "Stack: ";
	while(show_ptr != NULL)
	{
		cout << show_ptr->element << "\n";
		show_ptr = show_ptr->next;
		if (show_ptr != NULL)
			cout << "       ";
	}
}

string Stack::top()
{
	return first->element;
}
#include "LinkedList.h"

// move the current node in the list forward one node
void List::Skip()
{
	assert(!AtEnd());
	pred = current;
	current = current->next;
	pred->next = current;
}

// Insert a node in front of the current node
void List::Insert(const NodeData &d)
{
	Node *temp = new(nothrow) Node(d);
	assert(temp != NULL);
	
	// if first == current, list is either empty or you are entering node in front
	// of current. either way, first needs to be updated.
	if (first == current)
	{
		temp->next = first;
		first = temp;
	}
	// put new node in front of current node
	else
	{		
		temp->next = current;
		pred->next = temp;
	}
	pred = temp;
}

// delete the current node
void List::Delete()
{
	assert(!AtEnd());
	
	// if first == current, need to delete node and update first node
	if (first == current)
	{
		first = current->next;
		delete current;
		current = first;
	}
	// delete current node and make current successor node
	else
	{
		pred->next = current->next;
		delete current;
		current = pred->next;
	}
}

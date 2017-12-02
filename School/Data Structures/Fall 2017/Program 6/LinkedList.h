#include <cassert>
#include <climits>
#include "Point.h"
typedef Point NodeData;

class List
{
private:
	
	struct Node
	{
		NodeData data; 	// "content" of node
		Node    *next;	// link to next node
		
		// Constructor functions
		Node(){}
		Node(const NodeData &theData, Node *const theNext = 0)
				: data(theData), next(theNext) {}
	};
	
public:
	// Constructor
	List() : first(0), current(0), pred(0) {}
	
	// True if list empty
	bool Empty() const {return first == 0;}
	// True if current position is beyond the last entry
	bool AtEnd() const {return current == 0;}
	// Rewind current entry to beginning of list
	void Rewind() {current = first; pred = 0;}
	// Skip to the next entry in the list
	void Skip();
	
	// Get the contents of the current list entry
	NodeData CurrentEntry() const
	{
		assert(!AtEnd());
		return current->data;
	}
	
	// Insert a new list entry before the current entry
	void Insert(const NodeData &d);
	// Update the current entry
	void Update(const NodeData &d) {assert(!AtEnd()); current->data = d;}
	// Delete the current entry
	// the new current entry is the successor of the deleted node
	void Delete();
private:
	Node *first;		// point to first node in list
	Node *current;		// point to the current node
	Node *pred;			// point to node preceding curent node
};
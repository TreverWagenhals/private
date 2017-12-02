using namespace std;

#include <cassert>
#include "queue.h"

// Add an item to the tail of the queue.
void Queue::Enqueue(const QueueElem &elem)
{
	Node* temp = new(nothrow) Node(elem);
	assert(temp != NULL);
	
	// head == tail if head == NULL, so must also be assigned temp
	if (head == NULL)
		head = temp;
	// add temp after current tail
	else
		tail->next = temp;
	// update tail adress to be new temp node
	tail = temp;
}

// Remove and return the head item from the queue.
QueueElem Queue::Dequeue()
{
	assert (!Empty());
	QueueElem poppedData = head->data;
	Node *temp = head;
	head = head->next;
	if (head == NULL) 
		tail = NULL;
	delete temp;   
	return poppedData;
}

// Return but do not remove the head item from the queue.
QueueElem Queue::Head()
{
  // ensure not empty.
  assert(!Empty());
  // Return the head item data.
  return head->data;
}
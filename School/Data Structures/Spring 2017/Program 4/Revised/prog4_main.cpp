#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string>

#include "Stack.h"

#define TEMPLATE int	// change this to change template data type

using namespace std;

	
int main()
{
	Stack <TEMPLATE> s;
	TEMPLATE compare;
	TEMPLATE word;
	
	string command;
	
	while (1)
	{
		cout << "Enter command: ";
		cin >> command;
	
		if (command == "push")
		{
			cout << "Enter word: ";
			cin >> word;
			
			while (!(cin))
			{
				cout << "ERROR: Input did not match data type. Try again: ";
				cin.clear();
				cin.ignore(10000,'\n');
				cin >> word;
			}
			
			s.push(word);
			cout << s;
		}
		
		else if (command == "pop")
			if (s.empty())
				cout << "ERROR: Stack is empty \n\n";
			else
			{
				s.pop();
				cout << s;
			}
		
		else if (command == "match")
		{
			if (s.empty())
				cout << "ERROR: Stack is empty \n\n";
			else
			{
				cout << "Enter word: ";
				cin >> compare;
				if (s.top() == compare)
					cout << "User input " << compare << " matches top of stack \n\n";
				else
					cout << "User input " << compare << " doesn't match top of stack \n\n";
			}
		}
		
		else if (command == "exit")
		{
			s.~Stack();
			return 0;
		}
		
		else
			cout << "ERROR: invalid command " << command << "\n";
	}		
}
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string>

#include "Stack.h"

using namespace std;

	
int main()
{
	Stack s;
	string command;
	string compare;
	
	while (1)
	{
		cout << "Enter command: ";
		cin >> command;
	
		if (command == "push")
		{
			string word;
			cout << "Enter word: ";
			cin >> word;
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
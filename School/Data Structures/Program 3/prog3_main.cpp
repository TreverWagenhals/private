#include <iostream>
#include <algorithm>
#include <time.h>
#include "Card.h"
#include "DeckOfCards.h"

#define SHUFFLES (25)

using namespace std;

int main()
{
  int seed;
  char command;
  DeckOfCards x;
  
  cout << "Enter seed for RNG (-1 for truly random seed): ";
  cin >> seed;

  while(seed < -1 || !(cin))
  {
    cout << "ERROR: Seed must be positive number, or -1 for time based random generation. Try again: ";
    cin.clear();
    cin.ignore(10000,'\n');
    cin >> seed;
  }
  
  if (seed == -1)
    srand(time(NULL));
  else
    srand(seed);
  
  while (1)
  {
      cout << "Enter command (P : D : R : N : S : X): ";
      cin >> command;
      
      while(command != 'P' && command != 'D' && command != 'R' && command != 'N' && command != 'S' && command != 'X' || !(cin))
      {
          cout << "ERROR: Invalid command entered. Try again: ";
          cin.clear();
          cin.ignore(10000,'\n');
          cin >> command;
      }
      
      switch (command)
      {
          case 'P':
            x.printDeck();
            break;
          case 'D':
            x.getCard();
            break;
          case 'R':
            x.getRandomCard();
            break;
          case 'N':
            x.getSelectedCard();
            break;
          case 'S':
            x.shuffleDeck(SHUFFLES);
            break;
          case 'X':
            system("pause");
            return 0;
          
      }
  }
}
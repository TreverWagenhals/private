#include "Card.h"
#include <iostream>

// Initialize arrays with proper values
const char Card::suit[] = {'C', 'D', 'H', 'S'};
const char Card::value[] = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}; 

Card::Card(int s, int v)
{
  cardSuit = s;
  cardValue = v;
}

int Card::getValue()
{
    return cardValue;
}

int Card::getSuit()
{
    return cardSuit;
}

char Card::getCharValue()
{
  return(value[cardValue]);
}

char Card::getCharSuit()
{
  return(suit[cardSuit]);
}

void Card::setCard(int s, int v)
{
	cardSuit = s;
	cardValue = v;
}
	
void Card::getCard()
{
  std::cout << value[cardValue] << suit[cardSuit] << " ";
}
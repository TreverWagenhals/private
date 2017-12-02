#include "DeckOfCards.h"
#include <iostream>
#include <algorithm>

using namespace std;

#define NUMCARDS (5)    // This is how many cards will be drawn at a time

DeckOfCards::DeckOfCards()
{    
    for(int suit = 0; suit < SUITS; suit++)
    {
        for(int rank = 0; rank < RANKS; rank++)
        {
            Card card(suit, rank);          // Create card of each suit and rank combination
            deckOfCards.push_back(card);    // and add it to our vector
        }
    }
    currentCard = 0;                        // Initialize card count to 0 whenever a new deck is created
}

void DeckOfCards::printDeck()
{
    std::cout << "Current deck (" << NCARDS - currentCard << " cards remaining): \n";
    int count = 1;  // used to make sure only 13 cards per line are printed

    for (int i = currentCard; i < deckOfCards.size(); ++i)
    {
        deckOfCards[i].getCard();       // Prints all cards between the current card and end of deck
        if (count == 13)                // start new line at 13 cards
        {
          std::cout << "\n";
          count = 0;
        }
        count++;
    }
    std::cout << "\n";
}

void DeckOfCards::getCard()
{
    if(NCARDS - currentCard >= 5)                   // Make sure there's 5 cards to be drawn
    {
        std::cout << "Dealt top 5 cards: ";
        for(int i = 0; i < NUMCARDS; i++)           // Loop through printing a card 5 times
        {
            deckOfCards[currentCard++].getCard();   // Print current card and iterate current card at the same time
        }
    }
    else
        std::cout << "ERROR: Not enough cards. Shuffle deck and try again.";
    
    std::cout << "\n";
}

void DeckOfCards::shuffleDeck(int times)
{
    std::cout << "Shuffling ...\n";
    for(int j = 0; j < times; j++)                                  // Shuffle the deck n amount of times
    {
        for(int i = 0; i < NCARDS; i++)                             // Go through each card and swap it with a different card
        {
            std::swap(deckOfCards[i], deckOfCards[rand() % 52]);    // Make sure each card is swapped with another random card
        }
        currentCard = 0;
    }
    DeckOfCards::printDeck();                                       // Print new swapped deck
}

void DeckOfCards::getRandomCard()
{
    if(NCARDS - currentCard >= 5)
    {
        std::cout << "Dealt 5 random cards: ";
        for(int i = 0; i < NUMCARDS; i++)
        {
            getHelper(rand() % (NCARDS - currentCard));             // Get a random card with value less than remaining cards
        }
    }
    else
        std::cout << "ERROR: Not enough cards. Shuffle deck and try again.";
    std::cout << "\n";
}

void DeckOfCards::getSelectedCard()
{   

    if(NCARDS - currentCard >= 5)
    {
        int start;
        cout << "Enter starting position (0 - " << NCARDS - currentCard - 5 << "): ";
        cin >> start;
        while (start < 0 || start > (NCARDS - currentCard - 5) || !(cin))
        {
            cout << "ERROR: Card number not valid. Try again: ";
            cin.clear();
            cin.ignore(10000, '\n');
            cin >> start;
        }
        
        if(start > 0)
        {
            std::cout << "Dealt 5 cards starting at position " << start << ": ";
            for(int i = 0; i < NUMCARDS; i++)
                getHelper(start);   
            std::cout << "\n";
        }
        else
            DeckOfCards::getCard();
    }
    else
        std::cout << "ERROR: Not enough cards. Shuffle deck and try again.\n";
    
}

void DeckOfCards::getHelper(int card)
{
    // Create a temporary card that holds the information for the card being drawn
    Card temp(deckOfCards[card+currentCard].getSuit(), deckOfCards[card+currentCard].getValue());

    // We need to shift all the cards over into the drawn card's position and empty the next currentCard position
    for(int i = currentCard + card; i > currentCard; i--)
        deckOfCards[i] = deckOfCards[i-1];
    
    // Save temp card to currentCard and then print it before iterating the count
    deckOfCards[currentCard] = temp;
    deckOfCards[currentCard++].getCard();
}

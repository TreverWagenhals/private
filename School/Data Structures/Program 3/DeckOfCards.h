#ifndef DECKOFCARDS_H
#define DECKOFCARDS_H

#include <vector> 
#include "Card.h"

#define NCARDS (52)

class DeckOfCards
{
    public:
        //Constructor
        DeckOfCards();

        void printDeck();                  
        void getCard();                 // Gets NUMCARDS amount of cards (5 for the lab)
        void shuffleDeck(int times);    // Shuffle the dark numerous times to increase randomness
        void getRandomCard();          
        void getSelectedCard();
    
    private:
        std::vector<Card> deckOfCards;
        int currentCard;                // Keep track of where we are in deck instead of constantly destroying the deck
        void getHelper(int card);       // Helper function to shift vector values around to keep the deck accurate
};

#endif
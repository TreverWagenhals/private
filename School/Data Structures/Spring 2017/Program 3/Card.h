#ifndef CARD_H
#define CARD_H

#define SUITS (4)
#define RANKS (13)

#include <string>
class Card
{
    public:
        
        // Constructors
        Card();
        Card(int s, int v);
        
        // Getter Functions
        int getSuit();          // number location of suit in array
        int getValue();         // number location of value in array
        char getCharValue();    // actual value of card in array
        char getCharSuit();     // actual suit of card in array
        void getCard();         // print out suit and array combined
		
		// Setter Function
		void setCard(int s, int v); // NOTE: My program was written to only use the Constructor with parameters and thus the setter functions were never called
    
        // Public arrays of chars for Suits and Ranks
        const static char suit[];
        const static char value[];
 
    private:
        int cardSuit;
        int cardValue;
};

#endif
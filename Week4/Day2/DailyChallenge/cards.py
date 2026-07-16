import random


class Card:
    def __init__(self, suit, value):
        self.suit = suit
        self.value = value

    def __str__(self):
        return f"{self.value} of {self.suit}"


class Deck:
    def __init__(self):
        self.cards = []

        suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
        values = ["A", "2", "3", "4", "5", "6", "7",
                  "8", "9", "10", "J", "Q", "K"]

        for suit in suits:
            for value in values:
                self.cards.append(Card(suit, value))

    def shuffle(self):
        """Shuffle the deck if it contains all 52 cards."""

        if len(self.cards) == 52:
            random.shuffle(self.cards)
        else:
            print("Cannot shuffle because the deck is incomplete.")

    def deal(self):
        """Deal one card from the deck."""

        if len(self.cards) > 0:
            return self.cards.pop()
        else:
            return None
    
deck = Deck()

print(len(deck.cards))      # 52

deck.shuffle()

card = deck.deal()
print(card)

print(len(deck.cards))      # 51

card = deck.deal()
print(card)

print(len(deck.cards))      # 50
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
        values = ["A", "2", "3", "4", "5", "6",
                  "7", "8", "9", "10",
                  "J", "Q", "K"]

        for suit in suits:
            for value in values:
                self.cards.append(Card(suit, value))

    def shuffle(self):
        if len(self.cards) == 52:
            random.shuffle(self.cards)
        else:
            print("Cannot shuffle a deck that is missing cards.")

    def deal(self):
        if len(self.cards) == 0:
            return None

        return self.cards.pop()


# ---------- Testing ----------

deck = Deck()

print("Cards in deck:", len(deck.cards))

deck.shuffle()

card = deck.deal()

print("Card dealt:", card)

print("Cards remaining:", len(deck.cards))
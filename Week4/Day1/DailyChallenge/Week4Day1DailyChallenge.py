# Exercise 1

"""
What is a class?
A class is essentially a blueprint that you use in Python to group data and methods together.

What is an instance?
An object created from a class.

What is encapsulation?
The process of bundling data and behaviors together in a class.

What is abstraction?
The process of hiding implementation details and exposing only the necessary functionality.

What is inheritance?
The concept that allows a new class to inherit attributes and methods from an existing class.

What is multiple inheritance?
The process of inheriting from two or more parent classes.

What is polymorphism?
Different classes can use methods with the same name while providing different implementations.

What is Method Resolution Order (MRO)?
The order Python follows to search for methods and attributes in a class hierarchy, especially when multiple inheritance is involved.
"""



# Exercise 2
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
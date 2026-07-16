"""
Exercise 1

1. What is a class?
A class is a blueprint or template used to create objects. It defines the attributes and methods an object will have.

2. What is an instance?
An instance is a specific object created from a class.

3. What is encapsulation?
Encapsulation is the practice of bundling data and methods together inside a class while controlling access to them.

4. What is abstraction?
Abstraction means hiding unnecessary implementation details and exposing only the essential features of an object.

5. What is inheritance?
Inheritance allows one class (child) to inherit the attributes and methods of another class (parent).

6. What is multiple inheritance?
Multiple inheritance allows a class to inherit from more than one parent class.

7. What is polymorphism?
Polymorphism allows different classes to use methods with the same name while performing different actions.

8. What is Method Resolution Order (MRO)?
MRO is the order Python follows to determine which method to call when multiple classes define the same method.
"""

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
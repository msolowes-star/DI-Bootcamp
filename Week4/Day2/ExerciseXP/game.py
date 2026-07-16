import random


class Game:
    def get_user_item(self):
        """Ask the user to choose rock, paper, or scissors."""

        valid_items = ["rock", "paper", "scissors"]

        while True:
            user_item = input(
                "Select rock, paper, or scissors: "
            ).strip().lower()

            if user_item in valid_items:
                return user_item

            print("Invalid selection. Please choose rock, paper, or scissors.")

    def get_computer_item(self):
        """Randomly choose an item for the computer."""

        items = ["rock", "paper", "scissors"]
        return random.choice(items)

    def get_game_result(self, user_item, computer_item):
        """Compare the two items and return win, draw, or loss."""

        if user_item == computer_item:
            return "draw"

        winning_combinations = {
            "rock": "scissors",
            "paper": "rock",
            "scissors": "paper"
        }

        if winning_combinations[user_item] == computer_item:
            return "win"

        return "loss"

    def play(self):
        """Play one complete game and return its result."""

        user_item = self.get_user_item()
        computer_item = self.get_computer_item()

        result = self.get_game_result(user_item, computer_item)

        print(f"\nYou selected {user_item}.")
        print(f"The computer selected {computer_item}.")

        if result == "win":
            print("You win!")
        elif result == "loss":
            print("You lose!")
        else:
            print("You drew!")

        print()

        return result
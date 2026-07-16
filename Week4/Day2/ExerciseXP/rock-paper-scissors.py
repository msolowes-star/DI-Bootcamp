from game import Game


def get_user_menu_choice():
    """Display the menu and return the user's choice."""

    print("Rock, Paper, Scissors")
    print("---------------------")
    print("P - Play a new game")
    print("S - Show scores")
    print("Q - Quit")

    choice = input("Choose an option: ").strip().lower()

    valid_choices = ["p", "s", "q"]

    if choice in valid_choices:
        return choice

    print("Invalid menu choice. Please select P, S, or Q.\n")
    return None


def print_results(results):
    """Print the final results of all games played."""

    print("\nGame Results")
    print("------------")
    print(f"Wins:   {results['win']}")
    print(f"Losses: {results['loss']}")
    print(f"Draws:  {results['draw']}")
    print("\nThank you for playing!")


def main():
    """Run the main game menu."""

    results = {
        "win": 0,
        "loss": 0,
        "draw": 0
    }

    while True:
        choice = get_user_menu_choice()

        if choice == "p":
            game = Game()
            game_result = game.play()

            # Increase the appropriate score by 1.
            results[game_result] += 1

        elif choice == "s":
            print("\nCurrent Scores")
            print("--------------")
            print(f"Wins:   {results['win']}")
            print(f"Losses: {results['loss']}")
            print(f"Draws:  {results['draw']}\n")

        elif choice == "q":
            print_results(results)
            break


if __name__ == "__main__":
    main()
from anagram_checker import AnagramChecker


def show_menu():
    print("\n--- Anagram Checker ---")
    print("1. Enter a word")
    print("2. Exit")


def is_input_valid(user_input):
    user_input = user_input.strip()

    if len(user_input.split()) != 1:
        print("Error: Please enter only one word.")
        return False

    if not user_input.isalpha():
        print("Error: Please use only letters.")
        return False

    return True


def main():
    checker = AnagramChecker()

    while True:
        show_menu()
        choice = input("Choose an option: ")

        if choice == "2":
            print("Goodbye!")
            break

        elif choice == "1":
            user_word = input("Enter a word: ").strip()

            if not is_input_valid(user_word):
                continue

            word_upper = user_word.upper()

            print(f'\nYOUR WORD: "{word_upper}"')

            if checker.is_valid_word(user_word):
                print("This is a valid English word.")

                anagrams = checker.get_anagrams(user_word)

                if anagrams:
                    print("Anagrams for your word:", ", ".join(anagrams))
                else:
                    print("No anagrams found.")
            else:
                print("This is not a valid English word.")

        else:
            print("Invalid choice. Please choose 1 or 2.")


main()
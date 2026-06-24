import random

wordslist = [
    'correction',
    'childish',
    'beach',
    'python',
    'assertive',
    'interference',
    'complete',
    'share',
    'credit card',
    'rush',
    'south'
]

word = random.choice(wordslist)

guessed_letters = []
wrong_guesses = 0
max_wrong_guesses = 6

body_parts = [
    "head",
    "body",
    "left arm",
    "right arm",
    "left leg",
    "right leg"
]


def display_word():
    display = ""

    for letter in word:
        if letter == " ":
            display += " "
        elif letter in guessed_letters:
            display += letter
        else:
            display += "*"

    return display


print("Welcome to Hangman!")
print("Guess the word before the full body is drawn.")

while wrong_guesses < max_wrong_guesses:

    current_display = display_word()
    print("\nWord:", current_display)
    print("Guessed letters:", guessed_letters)
    print("Wrong guesses:", wrong_guesses, "out of", max_wrong_guesses)

    if "*" not in current_display:
        print("\nCongratulations! You guessed the word:", word)
        break

    guess = input("Guess a letter: ").lower()

    if len(guess) != 1 or not guess.isalpha():
        print("Please enter one letter only.")
        continue

    if guess in guessed_letters:
        print("You already guessed that letter. Try a different one.")
        continue

    guessed_letters.append(guess)

    if guess in word:
        print("Good guess!")
    else:
        print("Wrong guess! Adding:", body_parts[wrong_guesses])
        wrong_guesses += 1

if wrong_guesses == max_wrong_guesses:
    print("\nGame over!")
    print("The word was:", word)
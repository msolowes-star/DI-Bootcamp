# Exercise 1
import random


def get_words_from_file(file_path):
    with open(file_path, "r") as file:
        content = file.read()

    words = content.split()
    return words


import os
import random

def get_random_sentence(length):
    script_folder = os.path.dirname(__file__)
    file_path = os.path.join(script_folder, "words.txt")

    words = get_words_from_file(file_path)

    random_words = []

    for i in range(length):
        random_words.append(random.choice(words))

    sentence = " ".join(random_words)
    return sentence.lower()


def main():
    print("This program generates a random sentence from a word list.")

    user_input = input("Enter the sentence length between 2 and 20: ")

    try:
        length = int(user_input)

        if length < 2 or length > 20:
            print("Error: The number must be between 2 and 20.")
            return

        sentence = get_random_sentence(length)
        print(sentence)

    except ValueError:
        print("Error: Please enter a valid integer.")


main()

# Exercise 2
import json

sampleJson = """{ 
   "company":{ 
      "employee":{ 
         "name":"emma",
         "payable":{ 
            "salary":7000,
            "bonus":800
         }
      }
   }
}"""

data = json.loads(sampleJson)

salary = data["company"]["employee"]["payable"]["salary"]
print(salary)

data["company"]["employee"]["birth_date"] = "1995-04-12"

with open("modified_data.json", "w") as file:
    json.dump(data, file, indent=4)
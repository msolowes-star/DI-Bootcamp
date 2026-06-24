import random

list_of_numbers = [random.randint(0, 10000) for _ in range(20000)]

target_number = 3728

seen_numbers = set()

for number in list_of_numbers:

    complement = target_number - number

    if complement in seen_numbers:
        print(number, "and", complement)

    seen_numbers.add(number)
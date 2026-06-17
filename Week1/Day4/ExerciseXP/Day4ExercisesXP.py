# Exercise 1: Favorite Numbers

my_fav_numbers = {7, 18, 25}

my_fav_numbers.add(86)
my_fav_numbers.add(94)

my_fav_numbers.remove(94)

friend_fav_numbers = {3, 7, 10, 21}

our_fav_numbers = my_fav_numbers.union(friend_fav_numbers)

print(our_fav_numbers)

# Exercise 2: Tuple

my_tuple = (1, 2, 3)

# Tuples cannot be changed directly.
# This creates a NEW tuple:
my_tuple = my_tuple + (4, 5)

print(my_tuple)

# Exercise 3: List Manipulation

basket = ["Banana", "Apples", "Oranges", "Blueberries"]

basket.remove("Banana")
basket.remove("Blueberries")

basket.append("Kiwi")
basket.insert(0, "Apples")

print(basket.count("Apples"))

basket.clear()

print(basket)

# Exercise 4: Floats

# A float is a number with a decimal, like 1.5.
# An integer is a whole number, like 2.

numbers = []

for i in range(3, 11):
    numbers.append(i / 2)

print(numbers)

# Exercise 5: For Loop

for number in range(1, 21):
    print(number)

print("Even indexes:")

for index in range(20):
    if index % 2 == 0:
        print(index + 1)

# Exercise 6: While Loop

while True:
    name = input("Enter your name: ")

    if not name.isdigit() and len(name) >= 3:
        print("thank you")
        break
    else:
        print("Please enter a proper name.")

# Exercise 7: Favorite Fruits

favorite_fruits = input("Enter your favorite fruits separated by spaces: ")

fruits_list = favorite_fruits.split()

chosen_fruit = input("Enter the name of any fruit: ")

if chosen_fruit in fruits_list:
    print("You chose one of your favorite fruits! Enjoy!")
else:
    print("You chose a new fruit. I hope you enjoy it!")

# Exercise 8: Pizza Toppings

toppings = []

while True:
    topping = input("Enter a pizza topping, or type 'quit': ")

    if topping == "quit":
        break

    toppings.append(topping)
    print(f"Adding {topping} to your pizza.")

base_price = 10
topping_price = 2.50
total_cost = base_price + len(toppings) * topping_price

print("Your toppings are:", toppings)
print("Total cost: $" + str(total_cost))

# Exercise 9: Cinemax Tickets

total_cost = 0

while True:
    age = input("Enter age, or type 'done' to finish: ")

    if age == "done":
        break

    age = int(age)

    if age < 3:
        total_cost += 0
    elif age <= 12:
        total_cost += 10
    else:
        total_cost += 15

print("Total ticket cost: $" + str(total_cost))

# Exercise 9 Bonus

attendees = []

while True:
    name = input("Enter attendee name, or type 'done': ")

    if name == "done":
        break

    age = int(input("Enter attendee age: "))

    if age >= 16 and age <= 21:
        attendees.append(name)

print("Final list of attendees:", attendees)
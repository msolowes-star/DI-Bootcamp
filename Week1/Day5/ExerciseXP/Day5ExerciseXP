# Exercise 1: Convert two lists into a dictionary

keys = ['Ten', 'Twenty', 'Thirty']
values = [10, 20, 30]

result = dict(zip(keys, values))

print(result)

# Exercise 2: Cinemax #2

family = {"rick": 43, "beth": 13, "morty": 5, "summer": 8}

total_cost = 0

for name, age in family.items():
    if age < 3:
        price = 0
    elif age <= 12:
        price = 10
    else:
        price = 15

    print(f"{name} has to pay ${price}")
    total_cost += price

print(f"Total cost: ${total_cost}")

# Bonus:
family = {}

while True:
    name = input("Enter a family member's name, or type 'done' to finish: ")

    if name.lower() == "done":
        break

    age = int(input(f"Enter {name}'s age: "))
    family[name] = age

total_cost = 0

for name, age in family.items():
    if age < 3:
        price = 0
    elif age <= 12:
        price = 10
    else:
        price = 15

    print(f"{name} has to pay ${price}")
    total_cost += price

print(f"Total cost: ${total_cost}")

# Exercise 3: Zara

brand = {
    "name": "Zara",
    "creation_date": 1975,
    "creator_name": "Amancio Ortega Gaona",
    "type_of_clothes": ["men", "women", "children", "home"],
    "international_competitors": ["Gap", "H&M", "Benetton"],
    "number_stores": 7000,
    "major_color": {
        "France": "blue",
        "Spain": "red",
        "US": ["pink", "green"]
    }
}

brand["number_stores"] = 2

print(f"Zara's clients are people who buy clothes for {brand['type_of_clothes']}.")

brand["country_creation"] = "Spain"

if "international_competitors" in brand:
    brand["international_competitors"].append("Desigual")

brand.pop("creation_date")

print(brand["international_competitors"][-1])

print(brand["major_color"]["US"])

print(len(brand))

print(brand.keys())

# Bonus
more_on_zara = {
    "creation_date": 1975,
    "number_stores": 10000
}

brand.update(more_on_zara)

print(brand)

# Exercise 4: Disney Characters

users = ["Mickey", "Minnie", "Donald", "Ariel", "Pluto"]

# 1. Characters as keys, indexes as values
disney_users_A = {}

for index, character in enumerate(users):
    disney_users_A[character] = index

print(disney_users_A)


# 2. Indexes as keys, characters as values
disney_users_B = {}

for index, character in enumerate(users):
    disney_users_B[index] = character

print(disney_users_B)


# 3. Sorted characters as keys, indexes as values
sorted_users = sorted(users)

disney_users_C = {}

for index, character in enumerate(sorted_users):
    disney_users_C[character] = index

print(disney_users_C)
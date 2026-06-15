# Exercise 1
print("Hello world\nHello world\nHello world\nHello world")

# Exercise 2
print((99 ** 3) * 8)

# Exercise 3
# My guesses:
# 5 < 3           -> False
# 3 == 3          -> True
# 3 == "3"        -> False
# "3" > 3         -> TypeError
# "Hello" == "hello" -> False

print(5 < 3)
print(3 == 3)
print(3 == "3")
print("Hello" == "hello")

# Uncomment to test
# print("3" > 3)

# Exercise 4
computer_brand = "Lenova"
print(f"I have a {computer_brand} computer.")

# Exercise 5

name = "Marc"
age = 43
shoe_size = 43

info = f"My name is {name}, I am {age} years old, and I wear size {shoe_size} shoes."

print(info)

# Exercise 6

a = 12
b = 7

if a > b:
    print("Hello World")

# Exercise 7

number = int(input("Enter a number: "))

if number % 2 == 0:
    print("Even")
else:
    print("Odd")

# Exercise 8

user_name = input("What is your name? ")

if user_name.lower() == "marc":
    print("Wow! We have the same awesome name!")
else:
    print("Nice to meet you, but your name isn't as cool as mine 😄")

# Exercise 9

height = int(input("Enter your height in cm: "))

if height > 145:
    print("You are tall enough to ride!")
else:
    print("You need to grow some more to ride.")
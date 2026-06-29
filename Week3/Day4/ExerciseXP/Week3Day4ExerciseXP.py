from func import add_two_numbers
import random
import string
import datetime
from faker import Faker


# Exercise 1: Currencies

class Currency:
    def __init__(self, currency, amount):
        self.currency = currency
        self.amount = amount

    def __str__(self):
        if self.amount == 1:
            return f"{self.amount} {self.currency}"
        return f"{self.amount} {self.currency}s"

    def __repr__(self):
        return self.__str__()

    def __int__(self):
        return self.amount

    def __add__(self, other):
        if isinstance(other, int):
            return self.amount + other

        if isinstance(other, Currency):
            if self.currency == other.currency:
                return self.amount + other.amount
            raise TypeError(
                f"Cannot add between Currency type <{self.currency}> and <{other.currency}>"
            )

    def __iadd__(self, other):
        if isinstance(other, int):
            self.amount += other
            return self

        if isinstance(other, Currency):
            if self.currency == other.currency:
                self.amount += other.amount
                return self
            raise TypeError(
                f"Cannot add between Currency type <{self.currency}> and <{other.currency}>"
            )


c1 = Currency("dollar", 5)
c2 = Currency("dollar", 10)
c3 = Currency("shekel", 1)
c4 = Currency("shekel", 10)

print(c1)
print(int(c1))
print(repr(c1))
print(c1 + 5)
print(c1 + c2)

print(c1)

c1 += 5
print(c1)

c1 += c2
print(c1)

# Uncomment this line to test the error:
# print(c1 + c3)


# Exercise 2: Import

add_two_numbers(5, 7)


# Exercise 3: String module

letters = string.ascii_letters
random_string = ""

for i in range(5):
    random_string += random.choice(letters)

print(random_string)


# Exercise 4: Current Date

def display_current_date():
    today = datetime.date.today()
    print(today)


display_current_date()


# Exercise 5: Time left until January 1st

def time_until_january_first():
    now = datetime.datetime.now()
    next_year = now.year + 1
    january_first = datetime.datetime(next_year, 1, 1)

    time_left = january_first - now

    print(f"The time left until January 1st is: {time_left}")


time_until_january_first()


# Exercise 6: Birthday and minutes

def minutes_lived(birthdate):
    birthdate_object = datetime.datetime.strptime(birthdate, "%Y-%m-%d")
    now = datetime.datetime.now()

    time_lived = now - birthdate_object
    minutes = time_lived.total_seconds() / 60

    print(f"You have lived for approximately {int(minutes)} minutes.")


minutes_lived("1990-05-15")


# Exercise 7: Faker Module

fake = Faker()
users = []


def add_users(number_of_users):
    for i in range(number_of_users):
        user = {
            "name": fake.name(),
            "address": fake.address(),
            "language_code": fake.language_code()
        }

        users.append(user)


add_users(5)
print(users)
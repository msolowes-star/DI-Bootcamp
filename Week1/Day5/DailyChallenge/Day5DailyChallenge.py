#Challenge 1
word = input("Enter a word: ")

letter_dict = {}

for index, letter in enumerate(word):

    if letter in letter_dict:
        letter_dict[letter].append(index)

    else:
        letter_dict[letter] = [index]

print(letter_dict)

#Challenge 2
items_purchase = {
    "Water": "$1",
    "Bread": "$3",
    "TV": "$1,000",
    "Fertilizer": "$20"
}

wallet = "$300"

# Remove $ and commas
wallet = int(wallet.replace("$", "").replace(",", ""))

basket = []

for item, price in items_purchase.items():

    price = int(price.replace("$", "").replace(",", ""))

    if wallet >= price:
        basket.append(item)
        wallet -= price

if len(basket) == 0:
    print("Nothing")
else:
    print(sorted(basket))
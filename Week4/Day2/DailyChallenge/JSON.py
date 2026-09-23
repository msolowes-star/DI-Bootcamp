import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

# Fetch all posts
response = requests.get(f"{BASE_URL}/posts")
posts = response.json()

# ----------------------------------------
# Task 1
# ----------------------------------------
print("Task 1")
print(f"There are {len(posts)} posts.\n")

# ----------------------------------------
# Task 2
# ----------------------------------------
print("Task 2")
print("First post title:")
print(posts[0]["title"])

print("\nLast post title:")
print(posts[-1]["title"])
print()

# ----------------------------------------
# Task 3
# ----------------------------------------
print("Task 3")

qui_titles = [
    post["title"]
    for post in posts
    if "qui" in post["title"].lower()
]

print(f"Found {len(qui_titles)} titles containing 'qui'.")

print("\nFirst 3:")

for title in qui_titles[:3]:
    print("-", title)

print()

# ----------------------------------------
# Task 4
# ----------------------------------------
print("Task 4")

post_counts = {}

for post in posts:
    user_id = post["userId"]

    if user_id in post_counts:
        post_counts[user_id] += 1
    else:
        post_counts[user_id] = 1

for user_id, count in post_counts.items():
    print(f"User {user_id}: {count} posts")

print()

# ----------------------------------------
# Task 5
# ----------------------------------------
print("Task 5")

response = requests.get(f"{BASE_URL}/users/1")
user = response.json()

print(f"{user['name']} wrote {post_counts[1]} posts.")
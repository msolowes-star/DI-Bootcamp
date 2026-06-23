MATRIX_STR = '''
7ir
Tsi
h%x
i ?
sM# 
$a 
#t%'''

# Step 1: Convert the string into a 2D list
matrix = []

for line in MATRIX_STR.strip().split("\n"):
    matrix.append(list(line))

# Step 2 + 3 + 4: Read column by column
raw_message = ""

num_rows = len(matrix)
num_columns = len(matrix[0])

for column in range(num_columns):
    for row in range(num_rows):
        raw_message += matrix[row][column]

# Step 5: Replace symbols between letters with spaces
decoded_message = ""
previous_was_symbol = False

for char in raw_message:
    if char.isalpha():
        if previous_was_symbol and decoded_message != "":
            decoded_message += " "
        decoded_message += char
        previous_was_symbol = False
    else:
        previous_was_symbol = True

print(decoded_message)
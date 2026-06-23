MATRIX_STR = '''
7ir
Tsi
h%x
i ?
sM# 
$a 
#t%'''

# Step 1: Convert matrix string to rows
rows = MATRIX_STR.strip("\n").split("\n")

# Find the longest row
max_width = max(len(row) for row in rows)

# Create a rectangular matrix by padding shorter rows with spaces
matrix = []

for row in rows:
    matrix.append(list(row.ljust(max_width)))

# Step 2: Read the matrix column by column
raw_message_list = []

for column in range(max_width):
    for row in range(len(matrix)):
        raw_message_list.append(matrix[row][column])

raw_message = "".join(raw_message_list)

# Step 3 + 4: Replace groups of symbols between letters with spaces
decoded_message_list = []
previous_was_symbol = False

for char in raw_message:
    if char.isalpha():
        if previous_was_symbol and len(decoded_message_list) > 0:
            decoded_message_list.append(" ")

        decoded_message_list.append(char)
        previous_was_symbol = False
    else:
        previous_was_symbol = True

# Step 5: Print the decoded message
decoded_message = "".join(decoded_message_list)

print(decoded_message)
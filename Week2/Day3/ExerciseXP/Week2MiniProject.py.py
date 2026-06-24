# Tic Tac Toe

def create_board():
    return [
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]
    ]


def display_board(board):
    print("\n     1   2   3")
    print("   -------------")

    for row in range(3):
        print(f"{row + 1}  | {board[row][0]} | {board[row][1]} | {board[row][2]} |")
        print("   -------------")


def player_input(board, player):

    while True:
        try:
            row = int(input(f"\nPlayer {player}, enter row (1-3): ")) - 1
            col = int(input(f"Player {player}, enter column (1-3): ")) - 1

            if row not in range(3) or col not in range(3):
                print("Please enter numbers between 1 and 3.")
                continue

            if board[row][col] != " ":
                print("That spot is already taken.")
                continue

            return row, col

        except ValueError:
            print("Please enter a valid number.")


def check_win(board, player):

    # Check rows
    for row in board:
        if row.count(player) == 3:
            return True

    # Check columns
    for col in range(3):
        if (
            board[0][col] == player and
            board[1][col] == player and
            board[2][col] == player
        ):
            return True

    # Check diagonal top-left to bottom-right
    if (
        board[0][0] == player and
        board[1][1] == player and
        board[2][2] == player
    ):
        return True

    # Check diagonal top-right to bottom-left
    if (
        board[0][2] == player and
        board[1][1] == player and
        board[2][0] == player
    ):
        return True

    return False


def check_tie(board):

    for row in board:
        if " " in row:
            return False

    return True


def switch_player(player):

    if player == "X":
        return "O"
    else:
        return "X"


def play():

    board = create_board()
    current_player = "X"

    print("Welcome to Tic Tac Toe!")

    while True:

        display_board(board)

        row, col = player_input(board, current_player)

        board[row][col] = current_player

        if check_win(board, current_player):
            display_board(board)
            print(f"\n🎉 Player {current_player} wins!")
            break

        if check_tie(board):
            display_board(board)
            print("\n🤝 It's a tie!")
            break

        current_player = switch_player(current_player)


play()
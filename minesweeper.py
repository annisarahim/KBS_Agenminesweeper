import clips

def score(bombs, board_size):
    fact_array = []
    fact_string = "(board " + str(board_size) + " " + str(board_size) + ")"
    fact_array.append(fact_string)

    for bomb in bombs:
       (x_bomb, y_bomb) = bomb
       score = -1
       fact_string = "(score " + str(x_bomb) + " " + str(y_bomb) + " " + str(score) + ")"
       fact_array.append(fact_string)

    for i in range (board_size):
        for j in range (board_size):
            x, y, score = i, j, 0
            test = (x,y)
            if (test not in bombs):
                x_right, x_left, y_down, y_up = i + 1, i - 1, j + 1, j - 1
                for bomb in bombs:
                    (x_bomb, y_bomb) = bomb
                    if (((x_right == x_bomb) and (y == y_bomb)) or
                        ((x_right == x_bomb) and (y_down == y_bomb)) or
                        ((x == x_bomb) and (y_down == y_bomb)) or
                        ((x_left == x_bomb) and (y_down == y_bomb)) or
                        ((x_left == x_bomb) and (y == y_bomb)) or
                        ((x_left == x_bomb) and (y_up == y_bomb)) or
                        ((x == x_bomb) and (y_up == y_bomb)) or
                        ((x_right == x_bomb) and (y_up == y_bomb))):
                        score += 1
                fact_string = "(score " + str(i) + " " + str(j) + " " + str(score) + ")"
                fact_array.append(fact_string)
            # print(fact_string)
    for i in range (board_size):
        for j in range (board_size):
            fact_string1 = "(around_flag " + str(i) + " " + str(j) + " " + str(0)+ ")"
            fact_array.append(fact_string1)
            fact_string2 = "(around_closed " + str(i) + " " + str(j) + " " + str(0) + ")"
            fact_array.append(fact_string2)

    return fact_array

# Read info from txt
file = open("init.txt", "r")
lines = file.readlines()
init = []
for i in range (len(lines)):
    j = 0
    char = ''
    while (j < len(lines[i])):
        if (lines[i][j] != " ") and (lines[i][j] != '\n'):
            char += lines[i][j]
            if (j == (len(lines[i]) -1)):
                init.append(int(char))
        else:
            init.append(int(char))
            char =''
        j +=1
file.close()

# Extract info
board_size = init[0]
total_bomb = init[1]
bombs = []
j = 2
while (j < len(init)):
    bomb = (init[j], init[j+1])
    bombs.append(bomb)
    j +=2
print("Board size   = " + str(board_size))
print("Total bomb   = " + str(total_bomb))
print("Bomb(s)        = " + str(bombs))

# Create new CLIPS environment
env = clips.Environment()

# Insert initial facts to CLIPS
initial_board_fact = score(bombs, board_size)
for fact in initial_board_fact:
    print(fact)
print ("factss printed")
for i in range (len(initial_board_fact)):
    fact_string = initial_board_fact[i]
    fact = env.assert_string(fact_string)

env.load('ms.clp')
env.reset()
env.run()
print("here")
for fact in env.facts():
    print(fact)

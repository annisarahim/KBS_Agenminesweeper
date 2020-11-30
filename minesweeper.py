import clips
import termcolor
from termcolor import cprint

# Mengembalikan array dari fakta dan output matrix
def score(bombs, board_size):
    matrix = [['X' for i in range (board_size)] for j in range(board_size)]

    fact_array = []
    fact_string = "(board " + str(board_size) + " " + str(board_size) + ")"
    fact_array.append(fact_string)
    total_bomb = len(bombs)
    fact_string = "(total_bomb " + str(total_bomb) + ")"
    fact_array.append(fact_string)
    fact_string = "(total_flag " + str(0) + ")"
    fact_array.append(fact_string)


    for bomb in bombs:
       (x_bomb, y_bomb) = bomb
       score = -1
       fact_string = "(closed " + str(x_bomb) + " " + str(y_bomb) + " " + str(score) + ")"
       fact_array.append(fact_string)
       matrix[y_bomb][x_bomb]=str(score)

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
                fact_string = "(closed " + str(i) + " " + str(j) + " " + str(score) + ")"
                fact_array.append(fact_string)
                matrix[j][i] = str(score)
            # print(fact_string)
    for i in range (board_size):
        for j in range (board_size):
            fact_string1 = "(around_flag " + str(i) + " " + str(j) + " " + str(0)+ ")"
            fact_array.append(fact_string1)
            fact_string2 = "(around_closed " + str(i) + " " + str(j) + " " + str(0) + ")"
            fact_array.append(fact_string2)

    return fact_array, matrix

# Mengembalikan matriks
def printmatrix(matrix,b_size):
    for i in range (b_size):
        for j in range (b_size):
          if (matrix[i][j] == 'F'):
              cprint(matrix[i][j], 'red', attrs=['bold'], end=" ")
          elif (matrix[i][j] == 'X'):
              print(matrix[i][j], end=" ")
          else:
              angka = int(matrix[i][j])
              if (angka > 0):
                  if (angka % 5 == 0):
                      cprint(matrix[i][j], 'cyan', end=" ")
                  elif (angka % 5 == 1):
                      cprint(matrix[i][j], 'blue', end=" ")
                  elif (angka % 5 == 2):
                      cprint(matrix[i][j], 'magenta', end=" ")
                  elif (angka % 5 == 3):
                      cprint(matrix[i][j], 'green', end=" ")
                  elif (angka % 5 == 4):
                      cprint(matrix[i][j], 'yellow', end=" ")
              else:
                  print(".", end=" ")
          if (j == (b_size-1)):
              print("")
                
# Read info from txt
file = open("init.txt", "r")
lines = file.readlines()
init = []
for i in range (len(lines)):
    j = 0
    char = ''
    while (j < len(lines[i])):
        if ((lines[i][j] != ',') and (lines[i][j] != '\n')) :
            char += lines[i][j]
            if (j == (len(lines[i]) -1)):
                init.append(int(char))
        else:
            init.append(int(char))
            char =''
        
        if ((lines[i][j] == ',') and ((lines[i][j+1] == " ") and (j+1) < len(lines[i]))) :
            j+= 2
        else :
            j+=1
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
env.load('ms.clp')

# Insert initial facts to CLIPS
initial_board_fact, matrix  = score(bombs, board_size)

i = int
for i in range (len(initial_board_fact)):
    fact_string = initial_board_fact[i]
    fact = env.assert_string(fact_string)

print("WELCOME TO MINESWEEPER!!")
print("Let's Play!")

i = input("Press enter to start!")

#Draw board 
for i in range (init[0]):
  for j in range (init[0]):
    matrix[i][j] = "X"
printmatrix(matrix,init[0])


win = False
flags=[]
while not(win):
  env.run(1)
  draw = False
  for fact in env.facts():
    draw = False

    # Menandai pada matriks apabila ada flag pada tile 
    if fact.template.name == 'flag':
      x = str(fact[0])
      y = str(fact[1])
      score = str(fact[2])
      if (matrix[int(y)][int(x)] != 'F'):
        flags.append((fact[0],fact[1]))
        matrix[int(y)][int(x)] = 'F'
        print("")
        print(fact.template.name,x,y)
        draw = True
    
    # Menandai pada matriks apabila ada tile yang dibuka
    elif fact.template.name == 'probed':
      x = str(fact[0])
      y = str(fact[1])
      score = str(fact[2])
      
      if (matrix[int(y)][int(x)] != score):
        matrix[int(y)][int(x)] = score
        #jika score pada elemen lebih dari 0
        if (fact[2]>0):
          print("")
          print(fact.template.name,x,y)
          draw = True
    
    # Menandai apabila sudah pada kondisi berhenti 
    elif (fact.template.name == 'win'):
      lose = False
      for flag_ in flags :
        if flag_ not in bombs :
          lose = True

      if not lose :
        print("")
        print("You win!")
        print("final matrix:")
      else :
        print("Sorry, you're wrong:(")
      draw = True
      win = True

    if (draw):
      printmatrix(matrix, init[0]) 
      # uncomment this for steps
      # step = input()

print()
print("Initial Bomb(s): ",bombs)
print("Flags Result: ",flags)

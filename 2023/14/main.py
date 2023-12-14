from copy import deepcopy

import time

start_time = time.time()

# FILENAME = "sample.txt"
FILENAME = "input.txt"

with open(FILENAME) as f:
    matrix = [list(row) for row in f.read().split("\n")]

def transpose(matrix):
    return tuple(["".join(row) for row in zip(*matrix)])

def tilt(matrix, reverse = False):
    tilted = []
    for row in matrix:
        split_by_rock = [sorted(item, reverse=reverse) for item in row.split('#')]
        recomposed_row = "#".join("".join(item) for item in split_by_rock)
        tilted.append(recomposed_row)
    return tuple(tilted)

def do_cycle(matrix):
    # north, west, south, east
    directions = [True, True, False, False]
    for direction in directions:
        matrix = transpose(matrix)
        matrix = tilt(matrix, direction)
    return matrix

def count_total_load(matrix):
    total = 0
    for row in matrix:
        for i in range(len(row)):
            if row[i] == "O":
                total += len(row) - i
    return total

def challenge_one(matrix):
    return count_total_load(tilt(transpose(matrix), True))

def challenge_two(matrix):
    memory, matrix_list= {}, {}
    i = 1
    while True:
        matrix = do_cycle(matrix)
        if (matrix in memory):
            index = (10**9 - memory[matrix]) % (i - memory[matrix]) + memory[matrix]
            # print ("Index", index)
            return count_total_load(transpose(matrix_list[index]))
        memory[matrix] = i
        matrix_list[i] = matrix
        i += 1

print("Challenge 1:", challenge_one(matrix))
print("Challenge 2:", challenge_two(matrix))

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

from copy import deepcopy

import time

start_time = time.time()

with open("./input.txt") as fin:
    data = [lines.split("\n")
                for lines in fin.read().strip().split("\n\n")]

def transpose(grid):
    return list(zip(*grid))

def check_orientation(grid, index):
    nLines, nCols = len(grid), len(grid[0])

    for c in range(nCols):
        for l in range(nLines):
            mirror = (index * 2 + 1) - l
            # print (index, index * 2 + 1, l, mirror)
            if mirror < 0 or mirror >= nLines :
                continue
            # print (l,c,grid[l][c], grid[mirror][c])
            if grid[l][c] != grid[mirror][c]:
                # print ("vertical", l,c,grid[l][c], grid[mirror][c])
                return "vertical"

    return "horizontal"

def get_reflection(grid, ignoreVertical = -1, ignoreHorizontal = -1):
    nLines, nCols = len(grid), len(grid[0])

    horizontal = -1
    for i in range(nLines - 1):
        orientation = check_orientation(grid, i)
        if (orientation == "horizontal" and ignoreHorizontal != i):
            horizontal = i
            break

    # transpose the grid
    vertical = -1
    for j in range(nCols - 1):
        orientation = check_orientation(transpose(grid), j)
        if (orientation == "horizontal" and ignoreVertical != j):
            vertical = j
            break

    # if vertical == -1 and horizontal == -1:
    #     raise Exception("ERROR")

    return (vertical, horizontal)

def challenge_one(grid):
    vertical, horizontal = get_reflection(grid)
    result = 0
    if vertical != -1:
        result += vertical + 1
    elif horizontal != -1:
        result += 100 * (horizontal + 1)

    return result

def challenge_two(grid: list[str]):
    originalVertical, originalHorizontal = get_reflection(grid)
    nLines, nCols = len(grid), len(grid[0])

    result = 0
    for i in range(nLines):
        for j in range(nCols):
            gridCopy = deepcopy(grid)
            temp = list(gridCopy[i])
            if grid[i][j] == "#":
                temp[j] = '.'
            else:
                temp[j] = '#'
            gridCopy[i] = ''.join(temp)

            vertical, horizontal = get_reflection(gridCopy, originalVertical, originalHorizontal)

            # skip si pas de reflection ou si c'est la reflection originale
            if ((vertical == -1 and horizontal == -1) or (vertical == originalVertical and horizontal == originalHorizontal)):
                continue

            if vertical != -1:
                result = vertical + 1
            elif horizontal != -1:
                result = 100 * (horizontal + 1)

    return result


c1 = 0
c2 = 0
for grid in data:
    c1 += challenge_one(grid)
    c2 += challenge_two(grid)

print("Challenge 1:", c1)
print("Challenge 2:", c2)
print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

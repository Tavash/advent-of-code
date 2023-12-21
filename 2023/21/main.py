from collections import defaultdict
import re
import time
import sys

with open(sys.argv[1]) as file:
    data = [x.strip() for x in file.readlines()]

nLines, nCols = len(data), len(data[0])
directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]


def get_grid_and_start():
    grid = {}
    start = (0, 0)
    for i in range(nLines):
        for j in range(nCols):
            grid[(i, j)] = data[i][j]
            if data[i][j] == "S":
                start = (i, j)
    return grid, start


def get_neighbors(grid, position):
    x, y = position
    return [
        (x + dx, y + dy)
        for dx, dy in directions
        if 0 <= x + dx < nLines and 0 <= y + dy < nCols and grid[x + dx, y + dy] != "#"
    ]


def count_garden_plots(grid, start, max_distance):
    q = [(0, start)]
    visited = set()
    total_garden_plots = 0
    modulo = max_distance % 2
    while q:
        distance, position = q.pop(0)
        if distance > max_distance:
            break
        if position in visited:
            continue
        if distance % 2 == modulo:
            total_garden_plots += 1

        visited.add(position)

        for new_pos in get_neighbors(grid, position):
            if new_pos not in visited:
                q.append((distance + 1, new_pos))
    return total_garden_plots


def challenge_one():
    return count_garden_plots(*get_grid_and_start(), 64)


def challenge_two():
    return 0


start_time = time.time()
c1 = challenge_one()
c1_time_execution = time.time() - start_time
print()
print("Challenge 1:", c1)
print("--- %s seconds ---" % (round(c1_time_execution, 3)))
print()

c2 = challenge_two()
c2_time_execution = time.time() - start_time - c1_time_execution
print("Challenge 2:", c2)
print("--- %s seconds ---" % (round(c2_time_execution, 3)))
print()

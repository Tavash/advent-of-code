import re
import time

start_time = time.time()

with open("input.txt") as f:
    lines = f.read().split("\n")


actions1 = {
    "toggle": lambda x: 1 if x == 0 else 0,
    "turn on": lambda x: 1,
    "turn off": lambda x: 0,
}

actions2 = {
    "toggle": lambda x: x + 2,
    "turn on": lambda x: x + 1,
    "turn off": lambda x: 0 if x == 0 else x - 1,
}


def get_instruction(line):
    match = re.match(r"(toggle|turn on|turn off) (\d+,\d+) through (\d+,\d+)", line)
    action, start, end = match.groups()
    return action, tuple(map(int, start.split(","))), tuple(map(int, end.split(",")))


def do_instruction(grid, lines, actions):
    for line in lines:
        action, start, end = get_instruction(line)
        for x in range(start[0], end[0] + 1):
            for y in range(start[1], end[1] + 1):
                grid[x][y] = actions[action](grid[x][y])


def challenge_one():
    grid = [[0 for _ in range(1000)] for _ in range(1000)]
    do_instruction(grid, lines, actions1)
    return sum([sum(row) for row in grid])


def challenge_two():
    grid = [[0 for _ in range(1000)] for _ in range(1000)]
    do_instruction(grid, lines, actions2)
    return sum([sum(row) for row in grid])


print("Challenge 1:", challenge_one())
print("Challenge 2:", challenge_two())

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

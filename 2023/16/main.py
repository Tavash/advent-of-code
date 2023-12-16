import time
import sys

start_time = time.time()

with open(sys.argv[1]) as file:
    matrix = file.read().strip().split("\n")

nLines, nCols = len(matrix), len(matrix[0])
directions = {"R": (0, 1), "L": (0, -1), "U": (-1, 0), "D": (1, 0)}
# inv_directions = {v: k for k, v in directions.items()}
mirrors = {
    ("R", "/"): "U",
    ("D", "/"): "L",
    ("L", "/"): "D",
    ("U", "/"): "R",
    ("R", "\\"): "D",
    ("U", "\\"): "L",
    ("L", "\\"): "U",
    ("D", "\\"): "R",
}


def get_energized_count(start=(0, 0, "R")):
    beams = [start]
    visited = set()

    while beams:
        x, y, direction = beams.pop()

        if not (0 <= x < nLines and 0 <= y < nCols) or (x, y, direction) in visited:
            continue

        visited.add((x, y, direction))

        if matrix[x][y] == "/":
            direction = mirrors[(direction, "/")]
        elif matrix[x][y] == "\\":
            direction = mirrors[(direction, "\\")]
        elif matrix[x][y] == "-":
            if directions[direction][0]:
                direction = "R"
                beams.append((x, y, "L"))
        elif matrix[x][y] == "|":
            if directions[direction][1]:
                direction = "D"
                beams.append((x, y, "U"))

        dx, dy = directions[direction]
        beams.append((x + dx, y + dy, direction))

    energized = {nrg[:2] for nrg in visited}

    return len(energized)


def challenge_one():
    return get_energized_count()


def challenge_two():
    all_max = []
    all_max.append(max(get_energized_count((0, i, "D")) for i in range(nCols)))
    all_max.append(max(get_energized_count((0, i, "U")) for i in range(nCols)))
    all_max.append(max(get_energized_count((i, 0, "L")) for i in range(nLines)))
    all_max.append(max(get_energized_count((i, 0, "R")) for i in range(nLines)))
    return max(all_max)


print("Challenge 1:", challenge_one())
print("Challenge 2:", challenge_two())

print()
print("--- %s seconds ---" % (round(time.time() - start_time, 3)))
print()

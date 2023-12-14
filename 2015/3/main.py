import time

start_time = time.time()

FILENAME = "input.txt"

with open(FILENAME) as f:
    lines = f.readlines()


def get_position(i, position):
    x, y = position
    match i:
        case "^":
            position = (x, y + 1)
        case "v":
            position = (x, y - 1)
        case "<":
            position = (x - 1, y)
        case ">":
            position = (x + 1, y)

    return position


def challenge_one(line):
    houses = {}
    houses[(0, 0)] = 1
    santa_position = (0, 0)

    for i, direction in enumerate(line):
        santa_position = get_position(direction, santa_position)
        houses[santa_position] = (
            houses[santa_position] + 1 if santa_position in houses else 1
        )

    return sum(1 for h in houses if houses[h] > 0)


def challenge_two(line):
    houses = {}
    houses[(0, 0)] = 2
    santa_position = robot_position = (0, 0)

    for i, direction in enumerate(line):
        if i % 2 == 0:
            santa_position = get_position(direction, santa_position)
            houses[santa_position] = (
                houses[santa_position] + 1 if santa_position in houses else 1
            )
        else:
            robot_position = get_position(direction, robot_position)
            houses[robot_position] = (
                houses[robot_position] + 1 if robot_position in houses else 1
            )

    return sum(1 for h in houses if houses[h] > 0)


print("Challenge 1:", challenge_one(lines[0]))
print("Challenge 2:", challenge_two(lines[0]))

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

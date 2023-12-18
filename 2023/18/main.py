import time
import sys

start_time = time.time()

with open(sys.argv[1]) as file:
    dig_plan = [i.split(" ") for i in file.read().strip().split("\n")]

directions = {
    "R": (0, 1),
    "L": (0, -1),
    "U": (-1, 0),
    "D": (1, 0),
    "0": (0, 1),
    "1": (1, 0),
    "2": (0, -1),
    "3": (-1, 0),
}


def calculate_area(path):
    """
    Calculate the area of a polygon defined by a list of points (path).
    The area is calculated using the formula for the area of a polygon given its vertices.
    Half the number of points in the path and 1 are added to the result.

    Args:
    path -- list of tuples [(x, y), ...]

    Returns:
    The calculated area
    """
    area = 0
    num_points = len(path)
    for i in range(num_points):
        x1, y1 = path[i]
        x2, y2 = path[
            (i + 1) % num_points
        ]  # Get the next point, or the first point if we're at the end
        area += x1 * y2 - y1 * x2
    area = abs(area) // 2
    # Floor division //
    # The “//” operator is used to return the closest integer value which is less than or equal to a specified expression or value.
    # So from the above code, 5//2 returns 2. You know that 5/2 is 2.5, and the closest integer which is less than or equal is 2[5//2].
    # (it is inverse to the normal maths, in normal maths the value is 3).
    return area + num_points // 2 + 1


def challenge_one():
    path = [(0, 0)]
    x, y = path[-1]
    for dir, meter, _ in dig_plan:
        dx, dy = directions[dir]
        for _ in range(int(meter)):
            x, y = x + dx, y + dy
            path.append((x, y))
    return calculate_area(path)


def challenge_two():
    path = [(0, 0)]
    for _, _, color in dig_plan:
        direction_digit = color[-2]
        hexadecimal_digits = color[2:-2]
        dx, dy = directions[direction_digit]
        meter = int(hexadecimal_digits, 16)  # convert hexa to int
        x, y = path[-1]

        for _ in range(int(meter)):
            x, y = x + dx, y + dy
            path.append((x + dx, y + dy))

        # path.extend(((x + dx * j, y + dy * j) for j in range(1, meter + 1)))
    return calculate_area(path)


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

import heapq
import time
import sys

start_time = time.time()

with open(sys.argv[1]) as file:
    matrix = file.read().strip().split("\n")

nLines, nCols = len(matrix), len(matrix[0])

directions = {(0, 1), (0, -1), (1, 0), (-1, 0)}


# optimize with heapq : https://docs.python.org/fr/3/library/heapq.html
# too slow with simple list and sort each time an item is added
def get_min_heat(start, end, move_min, move_max):
    visited = set()
    q = [(0, start[0], start[1], 0, 0)]

    while q:
        # pop the smallest heat value
        heat, x, y, dx, dy = heapq.heappop(q)
        # slow 😅
        # heat, x, y, dx, dy = q.pop(0)

        # if reach end coords, return final heat value
        if (x, y) == end:
            return heat

        if (x, y, dx, dy) in visited:
            continue

        visited.add((x, y, dx, dy))

        # can only turns left or right, remove opposite directions
        # ex: if coming from Right (0,1) => remove Left (-0,-1) and  Right (0,1). So only can go Up or Down
        allowed_directions = directions - {(-dx, -dy), (dx, dy)}

        for dx, dy in allowed_directions:
            h1, x1, y1 = heat, x, y
            # loop until 'move_max' (ex : 1 to 3)
            for i in range(move_max):
                # moving in direction
                x1, y1 = x1 + dx, y1 + dy
                # if x,y in matrix (inbounds)
                if 0 <= x1 < nLines and 0 <= y1 < nCols:
                    # update heat value
                    h1 += int(matrix[x1][y1])
                    # add to heapq if move_min not reached
                    if (i + 1) >= move_min:
                        heapq.heappush(q, (h1, x1, y1, dx, dy))
                        # slow 😅
                        # q.append((h1, x1, y1, dx, dy))
                        # q.sort()


def challenge_one():
    start = (0, 0)
    end = (nLines - 1, nCols - 1)
    return get_min_heat(start, end, 1, 3)


def challenge_two():
    start = (0, 0)
    end = (nLines - 1, nCols - 1)
    return get_min_heat(start, end, 4, 10)


print("Challenge 1:", challenge_one())
print("Challenge 2:", challenge_two())

print()
print("--- %s seconds ---" % (round(time.time() - start_time, 3)))
print()

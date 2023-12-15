import time
from functools import reduce

start_time = time.time()

# FILENAME = "sample.txt"
FILENAME = "input.txt"

with open(FILENAME) as f:
    codes = f.read().rstrip('\n').split(',')

def hash_algo(code):
    return reduce(lambda val, c: ((val + ord(c)) * 17) % 256, code, 0)

def challenge_one():
    return sum(hash_algo(code) for code in codes)

def challenge_two():
    map = {}
    for code in codes:
        label, lens = code.split('=') if '=' in code else (code.split('-')[0], None)
        box_number = hash_algo(label)
        map.setdefault(box_number, [])

        if lens:
            map[box_number] = [(la, le) if la != label else (label, lens) for la, le in map[box_number]]
            if label not in [la for la, _ in map[box_number]]:
                map[box_number].append((label, lens))
        else:
            map[box_number] = [(la, le) for la, le in map[box_number] if la != label]

    return sum((box_number + 1) * (i + 1) * int(lens) for box_number, tuples in map.items() for i, (label, lens) in enumerate(tuples))

# thanks copilot for reducing code lines ! 💯
print("Challenge 1:", challenge_one())
print("Challenge 2:", challenge_two())

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

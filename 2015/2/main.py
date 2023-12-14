import time

start_time = time.time()

FILENAME = "input.txt"

with open(FILENAME) as f:
    lines = f.read().split("\n")

# 2*l*w + 2*w*h + 2*h*l.
c1 = 0
c2 = 0
for l in lines:
    l, w, h = map(int, l.split("x"))
    tmp = (l * w, w * h, h * l)
    c1 += 2 * sum(tmp) + min(tmp)

    tmp = sorted([l, w, h])
    c2 += 2 * sum(tmp[:2]) + l * w * h

print("Challenge 1:", c1)
print("Challenge 2:", c2)

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

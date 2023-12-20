from math import prod
import re
import time
import sys

start_time = time.time()

with open(sys.argv[1]) as file:
    all_workflows, all_part_ratings = file.read().split("\n\n")

part_ratings = [
    {name: int(value) for name, value in re.findall(r"(\w*)=(\d*)", part)}
    for part in all_part_ratings.split("\n")
]

rules = {
    workflow_name: [
        r.split(":") if ":" in r else ["=", r] for r in workflow_rule.split(",")
    ]
    for workflow_name, workflow_rule in re.findall(
        r"^(\w*)\{(.*?)\}", all_workflows, re.M
    )
}


def is_accepted(destination, part_rating):
    if destination in ("A", "R"):
        return destination == "A"
    for cond, dest in rules[destination]:
        if cond == "=":
            return is_accepted(dest, part_rating)
        else:
            if eval(f"{part_rating[cond[0]]}{cond[1:]}"):
                return is_accepted(dest, part_rating)


def get_all_combinations(start):
    q = [start]
    total_combinations = 0

    while q:
        d, part_rating = q.pop(0)

        if d == "A":
            total_combinations += prod((x[1] - x[0]) + 1 for x in part_rating.values())
        elif d != "R":
            for cond, dest in rules[d]:
                if cond == "=":
                    q.append((dest, part_rating.copy()))
                else:
                    i = cond[0]  # x,m,a,s
                    i_range = part_rating[i]  # get range of xmas
                    operator = cond[1:2]
                    compared_value = int(cond[2:])

                    if operator == ">":
                        # Update i ranges
                        new_range_start = max(i_range[0], compared_value) + 1
                        part_rating = part_rating | {i: (new_range_start, i_range[1])}

                        q.append((dest, part_rating.copy()))

                        new_range_stop = min(i_range[1], compared_value)
                        part_rating = part_rating | {i: (i_range[0], new_range_stop)}
                    else:
                        # Update i ranges
                        new_range_stop = min(i_range[1], compared_value) - 1
                        part_rating = part_rating | {i: (i_range[0], new_range_stop)}

                        q.append((dest, part_rating.copy()))

                        new_range_start = max(i_range[0], compared_value)
                        part_rating = part_rating | {i: (new_range_start, i_range[1])}

    return total_combinations


def challenge_one():
    return sum(sum(pr.values()) for pr in part_ratings if is_accepted("in", pr))


def challenge_two():
    start = ("in", {x: (1, 4000) for x in "xmas"})
    return get_all_combinations(start)


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

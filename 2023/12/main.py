from functools import lru_cache

import time

@lru_cache # 💯🔥 memoize => https://wellsr.com/python/optimizing-recursive-functions-with-python-memoization/
def get_arrangements(row,group):
    row = row.lstrip('.') # supprime les '.' au début de la ligne
    # debug
    # print (row, group)
    # '', ()
    # '', (1,)
    # combinaison trouvée si group est vide et row est vide
    if len(row) == 0:
        if len(group) == 0:
            return 1
        return 0

    # combinaison trouvée si group est vide et row ne contient pas de '#'
    if len(group) == 0:
        if '#' not in row:
            return 1
        return 0

    # row commence par '#'
    if row.startswith('#'):
        current_group = group[0]

        # ex: "##" (4,) => impossible
        if len(row) < current_group:
            return 0

        # ex: "##.???" (3,1)
        if '.' in row[:current_group]:
            return 0

        # combinaison trouvée si taille row == current_group et group n'a qu'un élément
        if len(row) == current_group:
            if len(group) == 1:
                return 1
            return 0

        # la séparation d'un spring doit être par un '.' ou '?'
        if row[current_group] == '#':
            return 0

        # sinon on continue avec le reste de la ligne et le reste du group
        return get_arrangements(row[current_group+1:], group[1:])

    # commence forcément par un '?'
    # si "?###?" (4,) alors
    #   -> "####?" (4,)
    #   -> ".###?" (4,)
    return get_arrangements(row.replace("?", "#", 1), group) + get_arrangements(row[1:], group)


with open("input.txt") as input_file:
    input_lines = input_file.readlines()

start_time = time.time()

c1 = 0
c2 = 0
for line in input_lines:
    row, records_raw = line.split(" ")
    group = tuple([int(x) for x in records_raw.split(",")])

    row2 = "?".join([row] * 5)
    records2 = group * 5

    c1 += get_arrangements(row, group)
    c2 += get_arrangements(row2, records2)

print("Challenge 1:", c1)
print("Challenge 2:", c2)

print("--- %s seconds ---" % (time.time() - start_time))

# test = get_arrangements("?".join(["?.?.???????##?????"] * 5), (1,2,8)*5)
# print(test)

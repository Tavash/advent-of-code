import time

start_time = time.time()

with open("input.txt") as f:
    lines = f.read().split("\n")

def at_least_three_vowels(string):
    return sum(1 for c in string if c in "aeiou") >= 3

def at_least_one_letter_twice_in_a_row(string):
    return any(string[i] == string[i + 1] for i in range(len(string) - 1))

def does_not_contain_forbidden_strings(string):
    return all(fs not in string for fs in ["ab", "cd", "pq", "xy"])

def is_nice(string):
    return (
        at_least_three_vowels(string)
        and at_least_one_letter_twice_in_a_row(string)
        and does_not_contain_forbidden_strings(string)
    )

def contains_pair_of_two_letters_twice(string):
    return any(string.count(string[i:i+2]) >= 2 for i in range(len(string) - 1))

def contains_letter_repeated_with_one_letter_between(string):
    return any(string[i] == string[i + 2] for i in range(len(string) - 2))

def challenge_one():
    return sum(1 for line in lines if is_nice(line))

def challenge_two():
    return sum(1 for line in lines if contains_pair_of_two_letters_twice(line) and contains_letter_repeated_with_one_letter_between(line))

print("Challenge 1:", challenge_one())
print("Challenge 2:", challenge_two())

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

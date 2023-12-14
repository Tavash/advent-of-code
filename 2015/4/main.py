import hashlib
import time

start_time = time.time()

def find_lower_number_with_five_zeroes(key, zeroes=5):
    i = 0
    while True:
        if str(hashlib.md5(f"{key}{i}".encode()).hexdigest()).startswith("0" * zeroes):
            return i
        i += 1
    return i

print("Challenge 1:", find_lower_number_with_five_zeroes("iwrupvqb"))
print("Challenge 1:", find_lower_number_with_five_zeroes("iwrupvqb", 6))

print("--- %s seconds ---" % (round(time.time() - start_time, 3)))

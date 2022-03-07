import random

def weighted_random_by_dict(dict):
    rand_val = random.random()
    total = 0
    for k, v in dict.items():
        total += v
        if rand_val <= total:
            return k
    assert False, 'unreachable'

if __name__ == '__main__':
    print("You shouldn't be directly running me!")

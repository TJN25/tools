#!/Users/thomasnicholson/opt/anaconda3/bin/python

import os
import getopt
import json
import random
#TODO need to separate suffixes with vowels if needed
def load_file():
    script_path = os.path.dirname(os.path.abspath(__file__))
    with open(f"{script_path}/passwordinputs.json") as file:
        valid_sounds = json.load(file)
    return valid_sounds

def build_word(current_word, length_left, dict):
    if length_left <= 2:
        current_word += str(random.choice(dict['suffixes']))
        return current_word
    if current_word == "":
        current_word = random.choice(dict['prefixes'])
        current_word = build_word(current_word, length_left - len(current_word), dict)
    else:
        if current_word[-1] in dict['vowels']:
            selected_sound = random.choice(dict['letters'])
            current_word += str(selected_sound)
            current_word = build_word(current_word, length_left - len(selected_sound), dict)
        else:
            selected_sound = random.choice(dict['vowels'])
            current_word += str(selected_sound)
            current_word = build_word(current_word, length_left - len(selected_sound), dict)

    return current_word

if __name__ == '__main__':
    valid_sounds = load_file()
    print(build_word("", 10, valid_sounds))
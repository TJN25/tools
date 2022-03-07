#!/Users/thomasnicholson/opt/anaconda3/bin/python

import sys
import os
import getopt
import json
import random
from weighted_random import weighted_random_by_dict
#option

help = '''
Help message can go here
'''

def usage():
        print(help)


def run_getopts():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "l:psmh",
                                   ["length", "prefix", "suffix",
                                    "medical", "help"])
    except getopt.GetoptError as err:
        print(err)
        usage()
        sys.exit(2)
    word_length = 10
    prefix = False
    suffix = False
    medical = False

    for o, a in opts:
        if o in ('-h', '--help'):
            usage()
            sys.exit()
        elif o in ('-l', '--length'):
            word_length = a
            if word_length.isnumeric():
                word_length = int(word_length)
        elif o in ('-p', '--prefix'):
            prefix = True
        elif o in ('-s', '--suffix'):
            suffix = True
        elif o in ('-m', '--medical'):
            medical = True
        else:
            assert False, "unhandled option"
    return word_length, prefix, suffix, medical

def load_file(inputfile):

    with open(inputfile) as file:
        dict = json.load(file)
    return dict



def check_vowel_combination(selected_sound, current_word, dict):
    #print(f"{current_word} {selected_sound}")
    sound1 = str(current_word[-2:])
    if sound1 in dict['avoid']:
        current_word = current_word[:-1]
    sound2 = str(current_word[-1] + selected_sound[0])
    if sound2 in dict['avoid']:
        current_word = current_word[:-1]
    sound3 = str(current_word[-2:] + selected_sound[0])
    if sound3 in dict['avoid']:
        current_word = current_word[:-1]
        current_word = current_word[:-1]
    return current_word

def build_word(current_word, length_left, dict, letter_frequencies, prefix, suffix, medical):
    if length_left <= 2:
        if suffix:
            selected_sound = str(random.choice(dict['suffixes']))
        elif current_word[-1] not in dict['vowels']:
            selected_sound = random.choice(dict['vowels'])
        else:
            selected_sound = weighted_random_by_dict(letter_frequencies)
        current_word = check_vowel_combination(selected_sound, current_word, dict)
        if (current_word[-1] in dict['vowels'] or selected_sound[0] in dict['vowels']):
            current_word += selected_sound
        else:
            current_word += str(random.choice(dict['vowels']))
            current_word += selected_sound
        return current_word
    if current_word == "":
        if prefix:
            current_word = random.choice(dict['prefixes'])
        else:
            current_word = weighted_random_by_dict(letter_frequencies)
        current_word = build_word(current_word, length_left - len(current_word), dict, letter_frequencies, prefix, suffix, medical)
    else:
        if current_word[-1] in dict['vowels']:
            selected_sound = weighted_random_by_dict(letter_frequencies)
            current_word = check_vowel_combination(selected_sound, current_word, dict)
            current_word += str(selected_sound)
            current_word = build_word(current_word, length_left - len(selected_sound), dict, letter_frequencies, prefix, suffix, medical)
        else:
            selected_sound = random.choice(dict['vowels'])
            current_word = check_vowel_combination(selected_sound, current_word, dict)
            current_word += str(selected_sound)
            current_word = build_word(current_word, length_left - len(selected_sound), dict, letter_frequencies, prefix, suffix, medical)

    return current_word

if __name__ == '__main__':
    script_path = os.path.dirname(os.path.abspath(__file__))
    word_length, prefix, suffix, medical = run_getopts()
    valid_sounds = load_file(f"{script_path}/data/passwordinputs.json")
    letter_frequencies = load_file(f"{script_path}/data/letter_frequencies_3.json")
    suggested_word = build_word("", word_length, valid_sounds, letter_frequencies, prefix, suffix, medical)
    print(suggested_word)
import random
from .weighted_random import weighted_random_by_dict
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



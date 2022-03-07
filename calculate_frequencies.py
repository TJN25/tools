import json

def calculate_frequencies():
    letter_range = 1

    dict = {}

    file = open('../wordleSolver/english-words.txt', 'r')


    for letter_range in range(1, 4):
        file.seek(0)
        for line in file:
            word = line.rstrip()
            word_len = len(word)
            for i in range(0, word_len - (letter_range - 1)):
                letter = word[i:(i + letter_range)]
                if letter in dict:
                    dict[letter] += 1
                else:
                    dict[letter] = 1

        total = 0
        for key, value in dict.items():
            total += value

        for key, value in dict.items():
            dict[key] = value/total

        with open(f'data/letter_frequencies_{letter_range}.json', 'w') as outfile:
            json.dump(dict, outfile)

if __name__ == '__main__':
    # calculate_frequencies()
    print("You shouldn't be directly running me!")
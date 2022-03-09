import json
def load_file(inputfile):

    with open(inputfile) as file:
        dict = json.load(file)
    return dict



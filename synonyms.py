'''Semantic Similarity: starter code

Author: Michael Guerzhoy. Last modified: Nov. 20, 2023.
'''

import math


def norm(vec):
    '''Return the norm of a vector stored as a dictionary, as
    described in the handout for Project 3.
    '''

    sum_of_squares = 0.0
    for x in vec:
        sum_of_squares += vec[x] * vec[x]

    return math.sqrt(sum_of_squares)


def cosine_similarity(vec1, vec2):
    numerator = 0.0
    for key in vec1:
        if key in vec2:
            numerator += vec1.get(key)* vec2.get(key)

    denominator = norm(vec1) * norm(vec2)

    return numerator/denominator


def build_semantic_descriptors(sentences):
    semantic_descriptor = {}

    for sentence in sentences:
        for word in sentence:
            if word not in semantic_descriptor:
                semantic_descriptor[word] = {}
            for key in sentence:
                if word != key:
                    if key not in semantic_descriptor[word]:
                        semantic_descriptor[word][key] = 0
                    semantic_descriptor[word][key] += 1

    return semantic_descriptor


def build_semantic_descriptors_from_files(filenames):
    file_content = ""

    for filename in filenames:
        file_content += open(filename, "r", encoding="latin1").read()
        file_content = file_content.lower()
        file_content += " "

    replace_characters = [",", "-", "--", ":", ";"]
    for char in replace_characters:
        file_content = file_content.replace(char, " ")

    file_content = file_content.replace("!", ".")
    file_content = file_content.replace("?", ".")
    file_content = file_content.split('.')

    fin = []

    for line in file_content:
        if line:
            fin.append(line.split(" "))

    for line in fin:
        while "" in line:
            line.remove("")

    semantic_descriptor = build_semantic_descriptors(fin)

    return semantic_descriptor




def most_similar_word(word, choices, semantic_descriptors, similarity_fn):

    if word not in semantic_descriptors:
        return -1

    most_similar_word = []
    for i in choices:
        if i not in semantic_descriptors:
            most_similar_word.append(-1)
        else:
            most_similar_word.append(similarity_fn(semantic_descriptors[word], semantic_descriptors[i]))

    return choices[most_similar_word.index(max(most_similar_word))]



def run_similarity_test(filename, semantic_descriptors, similarity_fn):
    similar = 0.0
    file_content = open(filename, "r", encoding="latin1").read()
    file_content = file_content.lower()
    lines = file_content.split("\n")

    for line in lines:
        if line:
            most_similar = most_similar_word(line[0], line[2:], semantic_descriptors, similarity_fn)

            if line[1] == most_similar:
                similar += 1

    return similar / len(lines) * 100
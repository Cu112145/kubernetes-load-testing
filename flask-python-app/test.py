

def count_word_frequency(input_string):
    words_dictionary = {}
    split_string = input_string.split(" ")
    for word in  split_string: 
        if word in words_dictionary:
            words_dictionary[word] = words_dictionary[word] + 1 
        else:
            words_dictionary[word] = 1 
    return words_dictionary



input_string = "some text repeats more and some text repeats less"
res = count_word_frequency(input_string)
print(res)
# define a function that takes in a string like the above and returns a data structure which shows each unique word along with how many times it appeared